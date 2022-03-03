module P = {
  @react.component
  let make = (~children) => <p className="mb-2"> children </p>
}

module FormTest = {
  type t = {
    name: string,
    category: string,
    aboutYou: bool,
    age: int,
  }

  type inputs = {
    name: option<string>,
    category: option<string>,
    aboutYou: option<bool>,
    age: option<string>,
  }

  type tOptional = {
    name: option<string>,
    category: option<string>,
    aboutYou: option<bool>,
    age: option<int>
  }

  type formState = %ppx_ts.toGeneric(t)

  type path = %ppx_ts.keyOf(t)
}

let default = () => {
  module Form = ReactHookForm.Form(FormTest)

  let {handleSubmit, register, formState: { errors }, watch } = Form.use(Form.config(~mode=#onSubmit, ()))

  let onSubmit = (data: FormTest.t, _event) => {
    Js.log2("onSubmit", data)
  }

  let watchValues = watch(. [Name, AboutYou, Age])
  Js.log2("watch", watchValues)

  Js.log2("errors", errors)

  let firstName = register(. Name)
  let category = register(. Category)
  let aboutYou = register(. AboutYou)
  let age = register(. Age)

  <div>
    <form onSubmit={handleSubmit(. onSubmit)}>
      <div>
        {"firstName:"->React.string}
      </div>
      <div>
        <input
          className="border"
          onChange=firstName.onChange
          onBlur=firstName.onBlur
          ref=firstName.ref
          name=firstName.name
        />
      </div>
      <div>
        {"category:"->React.string}
      </div>
      <div>
        <input
          className="border"
          onChange=category.onChange
          onBlur=category.onBlur
          ref=category.ref
          name=category.name
        />
      </div>
      <div>
        {"aboutYou:"->React.string}
      </div>
      <div>
        <input
          type_="checkbox"
          onChange=aboutYou.onChange
          onBlur=aboutYou.onBlur
          ref=aboutYou.ref
          name=aboutYou.name
        />
      </div>
      <div>
        {"age:"->React.string}
      </div>
      <div>
        <input
          className="border"
          onChange=age.onChange
          onBlur=age.onBlur
          ref=age.ref
          name=age.name
        />
      </div>

      <input type_="submit" />
    </form>
  </div>
}
