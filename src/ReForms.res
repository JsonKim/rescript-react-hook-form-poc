module P = {
  @react.component
  let make = (~children) => <p className="mb-2"> children </p>
}

module FormTest = {
  type name = {
    first: string
  }

  type t = {
    name: name,
    category: string,
    aboutYou: string
  }

  type nameState<'a> = {
    first: 'a
  }

  type formState<'a> = {
    name: nameState<'a>,
    category: 'a,
    aboutYou: 'a
  }
}

let default = () => {
  module Form = ReactHookForm.Form(FormTest)

  let {handleSubmit, register, formState: { errors } } = Form.use(.
    ~config=Form.config(~mode=#onSubmit, ()),
    (),
  )

  let onSubmit = (data: FormTest.t, _event) => {
    data.name.first->Js.log
  }

  errors->Js.log

  let firstName = register(. "name.first")
  let category = register(. "category")
  let aboutYou = register(. "aboutYou")

  <div>
    <form onSubmit={handleSubmit(. onSubmit)}>
      <input
        onChange=firstName.onChange
        onBlur=firstName.onBlur
        ref=firstName.ref
        name=firstName.name
      />
      <input
        onChange=category.onChange
        onBlur=category.onBlur
        ref=category.ref
        name=category.name
      />
      <input
        onChange=aboutYou.onChange
        onBlur=aboutYou.onBlur
        ref=aboutYou.ref
        name=aboutYou.name
      />
      <input type_="submit" />
    </form>
  </div>
}
