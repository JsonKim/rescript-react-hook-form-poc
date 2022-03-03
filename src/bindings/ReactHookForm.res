%%raw(`
function modifyRecord(origin, name, value){
  return { ...origin, [name]: value }
}
`)

%%raw(`
function zipObj(keys, values) {
  const length = Math.min(keys.length, values.length);
  const ret = {};
  for (let i = 0; i < length; i++) {
    ret[keys[i]] = values[i];
  }

  return ret;
}
`)

module Control = {
  type t
}

module Error = {
  type t = {message: string, @as("type") type_: string}

  @module("react-hook-form")
  external get: (Js.Dict.t<t>, string) => option<t> = "get"
}

module Register = {
  type t = {
    onChange: ReactEvent.Form.t => unit,
    onBlur: ReactEvent.Focus.t => unit,
    ref: ReactDOM.domRef,
    name: string,
  }
}

module type FieldValues = {
  type t
  type inputs
  type tOptional
  type formState<'a>
  type path
  let path_keyToString: (path) => string
}

module Form = (FieldValues: FieldValues) => {
  type onSubmit = ReactEvent.Form.t => unit

  type formState = {
    errors: FieldValues.formState<option<Error.t>>,
    isDirty: bool,
    dirtyFields: FieldValues.formState<bool>,
    touchedFields: FieldValues.formState<bool>,
    isSubmitted: bool,
    isSubmitting: bool,
    isSubmitSuccessful: bool,
    isValid: bool,
    isValidating: bool,
    submitCount: int,
  }

  @deriving({abstract: light})
  type config = {
    @optinal
    mode: [#onSubmit | #onBlur | #onChange | #onTouched | #all],
    @optional
    revalidateMode: [#onSubmit | #onBlur | #onChange],
    @optional
    defaultValues: Js.Json.t,
    @optional
    shouldFocusError: bool,
    @optional
    shouldUnregister: bool,
    @optional
    shouldUseNativeValidation: bool,
    @optional
    delayError: int,
    @optional
    criteriaMode: [#firstError | #all],
  }

  type t = {
    clearErrors: (. string) => unit,
    control: Control.t,
    formState: formState,
    getValues: (. array<string>) => Js.Json.t,
    handleSubmit: (. (@uncurry FieldValues.t, ReactEvent.Form.t) => unit) => onSubmit,
    reset: (. option<Js.Json.t>) => unit,
    setError: (. string, Error.t) => unit,
    setFocus: (. string) => unit,
    setValue: (. string, Js.Json.t) => unit,
    register: (. string) => Register.t,
    watch: (. array<string>) => Js.Json.t,
  }

  @module("react-hook-form")
  external useInternal: (. ~config: config=?, unit) => t = "useForm"

  type t2 = {
    clearErrors: (. string) => unit,
    control: Control.t,
    formState: formState,
    getValues: (. array<string>) => FieldValues.inputs,
    handleSubmit: (. (@uncurry FieldValues.t, ReactEvent.Form.t) => unit) => onSubmit,
    reset: (. option<Js.Json.t>) => unit,
    setError: (. string, Error.t) => unit,
    setFocus: (. string) => unit,
    setValue: (. string, Js.Json.t) => unit,
    register: (. FieldValues.path) => Register.t,
    watch: (. array<FieldValues.path>) => FieldValues.inputs,
  }

  @val external modifyRecord: ('a, string, 'b) => t2 = "modifyRecord";
  @val external zipObj: ('a, 'b) => FieldValues.inputs = "zipObj";

  let use = (config) => {
    let r = useInternal(. ~config, ())

    let register = (. path: FieldValues.path) => {
      r.register(. path->FieldValues.path_keyToString)
    }

    let modify = (f) => (. names: array<FieldValues.path>) => {
      let keys = names->Belt.Array.map(FieldValues.path_keyToString)
      let values = f(. keys)
      zipObj(keys, values)
    }

    r
    ->modifyRecord("register", register)
    ->modifyRecord("getValues", modify(r.getValues))
    ->modifyRecord("watch", modify(r.watch))
  }

  @send
  external setErrorAndFocus: (t, string, Error.t, @as(json`{shouldFocus: true }`) _) => unit =
    "setError"

  @send external trigger: (t, string) => unit = "trigger"

  @send external triggerMultiple: (t, array<string>) => unit = "trigger"

  @send
  external triggerAndFocus: (t, string, @as(json`{shouldFocus: true}`) _) => unit = "trigger"
}

module WatchValues = {
  type rec input<'a, 'b> =
    | Text: input<string, string>
    | Texts: input<array<string>, array<option<string>>>
    | Checkbox: input<string, bool>
    | Checkboxes: input<array<string>, array<option<bool>>>

  @deriving({abstract: light})
  type config<'a> = {
    name: 'a,
    @optional
    control: Control.t,
    @optional
    defaultValue: Js.Json.t,
  }

  @module("react-hook-form")
  external use: (@ignore input<'a, 'b>, ~config: config<'a>=?, unit) => option<'b> = "useWatch"
}
