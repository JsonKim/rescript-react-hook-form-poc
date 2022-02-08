import { useForm } from 'react-hook-form'

interface Form {
  check: {
    one: boolean,
  },
  example: string,
  exampleRequired: string
}

const resolver = async (data: Form, context: object) => {
  if (data.exampleRequired.length === 0) {
    return {
      values: {},
      errors: {
        exampleRequired: {
          type: "",
          message: ""
        }
      }
    }
  }

  return {
    values: { c: data.check.one, examples: data.example + data.exampleRequired }, errors: {}
  }
};

const FormPage = () => {
  const { register, handleSubmit, watch, formState: { errors }, ...form } = useForm<Form>({ resolver });
  const onSubmit = data => console.log(data);

  console.log('watch: ', watch()); // watch input value by passing the name of it
  console.log('error: ', errors)

  const c1 = register("check.one");

  return (
    <div>
      {/* "handleSubmit" will validate your inputs before invoking "onSubmit" */}
      <form onSubmit={handleSubmit(onSubmit)}>
        {/* register your input into the hook by invoking the "register" function */}
        <input className='w-full text-sm leading-6 py-2 pl-2 border border-slate-600' defaultValue="test" {...register("example")} />
        
        {/* include validation with required or other standard HTML validation rules */}
        <input className='w-full text-sm leading-6 py-2 pl-2 border border-slate-600' {...register("exampleRequired", { required: true })} />
        {/* errors will return when field validation fails  */}
        {errors.exampleRequired && <span>This field is required</span>}

        <input type="checkbox" ref={c1.ref} onBlur={c1.onBlur} onChange={c1.onChange} name={c1.name} />

        <input type="submit" />
      </form>
    </div>

  );
}

export default FormPage
