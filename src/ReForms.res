module P = {
  @react.component
  let make = (~children) => <p className="mb-2"> children </p>
}

module FormTest = {
  @ppx_ts.keyOf @ppx_ts.toGeneric
  type t = {
    name: string,
    category: string,
    aboutYou: string,
  }
}

let default = () => {
  module Form = ReactHookForm.Form(FormTest)

  let {handleSubmit, register, formState: {errors}} = Form.use(Form.config(~mode=#onSubmit, ()))

  let onSubmit = (data: FormTest.t, _event) => {
    data.name->Js.log
  }

  errors->Js.log

  let firstName = register(. FormTest.Name)
  let category = register(. FormTest.Category)
  let aboutYou = register(. FormTest.AboutYou)

  <div>
    <form onSubmit={handleSubmit(. onSubmit)}>
      <input
        onChange=firstName.onChange onBlur=firstName.onBlur ref=firstName.ref name=firstName.name
      />
      <input
        onChange=category.onChange onBlur=category.onBlur ref=category.ref name=category.name
      />
      <input
        onChange=aboutYou.onChange onBlur=aboutYou.onBlur ref=aboutYou.ref name=aboutYou.name
      />
      <input type_="submit" />
    </form>
  </div>
}
