%%raw(`
  function modifyRecord(origin, name, value){
    return { ...origin, [name]: value }
  }
`)

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
  type t_toGeneric<'a>
  type t_keyOf
  let t_keyToString: t_keyOf => string
}

module Form = (FieldValues: FieldValues) => {
  type onSubmit = ReactEvent.Form.t => unit

  type formState = {
    errors: FieldValues.t_toGeneric<option<Error.t>>,
    isDirty: bool,
    dirtyFields: FieldValues.t_toGeneric<bool>,
    touchedFields: FieldValues.t_toGeneric<bool>,
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
    clearErrors: (. FieldValues.t_keyOf) => unit,
    // control: Control.t,
    formState: formState,
    getValues: (. array<FieldValues.t_keyOf>) => Js.Json.t,
    handleSubmit: (. (@uncurry FieldValues.t, ReactEvent.Form.t) => unit) => onSubmit,
    reset: (. option<Js.Json.t>) => unit,
    setError: (. FieldValues.t_keyOf, Error.t) => unit,
    setFocus: (. FieldValues.t_keyOf) => unit,
    setValue: (. FieldValues.t_keyOf, Js.Json.t) => unit,
    register: (. FieldValues.t_keyOf) => Register.t,
  }

  @module("react-hook-form")
  external useInternal: (. ~config: config=?, unit) => t = "useForm"

  @val external modifyRecord: ('a, string, 'b) => t = "modifyRecord"

  let use = config => {
    let r = useInternal(. ~config, ())

    let register = (. path: FieldValues.t_keyOf) => {
      r.register(. path)
    }

    modifyRecord(r, "register", register)
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
    // @optional
    // control: Control.t,
    @optional
    defaultValue: Js.Json.t,
  }

  @module("react-hook-form")
  external use: (@ignore input<'a, 'b>, ~config: config<'a>=?, unit) => option<'b> = "useWatch"
}
