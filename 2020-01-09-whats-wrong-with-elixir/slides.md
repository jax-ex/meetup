# HELLO

---

## Before we start

Why are we doing this?

```notes
Elixir is still our prefered language where it makes sense. This talk is not
about bashing Elixir but expaning our knowledge of functional concepts.

The goal is to leave here with a better understanding of fp.
```

---

## Reminder: What's great about Elixir

---

## Fault tolerance

* concurrency (and parrallelism)
* horizontal scalability

---

## primatives

---

### concepts

* process (mini application with it's own stack and gc)
* mailbox (a queue for messages to be processed)

---

### concurrency

* spawn (create a process)
* send (send a message to a process)
* receive (grab a message from the mailbox)

---

### fault tolerance

* link (recieve the exception from a process)
* trap (turn the linked exception into a message)
* monitor (get a notification when a process dies)

---

## Erlang VM's focus on stability

* performance and memory grows linearly
* stability and recovery more important than performance
* OTP's extensive set of tools to build applications

---

## Taking the best ideas from other communities (Ruby, Clojure, etc...)

* community driven solutions
* lessons learned from those communities

---

## Desire to be inclusive

---

# What's wrong with Elixir

---

## Purity

A function is pure when:
  * it's return value is always the same for the same inputs
  * has no side effects (no mutation of variables, IO, references, etc..)

---

Why is purity important?

* cacheable
* portable
* testable
* reasonable
* parrallelism

---

## Currying

---

```haskell
let add x y = x + y
let addOne = add 1 
addOne 5 -- returns 6
```

---

```javascript
function curry(fn) {
  const arity = fn.length;

  return function $curry(...args) {
    if (args.length < arity) {
      return $curry.bind(null, ...args);
    }

    return fn.call(null, ...args);
  };
}
```

---

```javascript
let add = curry((x, y) => x + y)
let addOne = add(1)
addOne(5) // returns 6
```

---

```elixir
defmodule Curry do
  def curry(fun) do
    {_, arity} = :erlang.fun_info(fun, :arity)
    curry(fun, arity, [])
  end

  def curry(fun, 0, arguments) do
    apply(fun, Enum.reverse arguments)
  end

  def curry(fun, arity, arguments) do
    fn arg -> curry(fun, arity - 1, [arg | arguments]) end
  end
end
```

---

```elixir
import Curry
add = curry(fn x, y -> x + y end)
addOne = add.(1)
addOne.(5) # returns 6
```

---

```elixir
defmodule Curried do
  import Curry

  def match term do
    curry(fn what -> (Regex.match?(term, what)) end)
  end

  def filter f do
    curry(fn list -> Enum.filter(list, f) end)
  end

  def replace what do
    curry(fn replacement, word -> 
      Regex.replace(what, word, replacement) 
    end)
  end
end
```

---

```elixir
has_spaces = Curried.match(~r/\s+/)

sentences = Curried.filter(has_spaces)

disallowed = Curried.replace(~r/[jruesbtni]/)

censored = disallowed.("*")

allowed = sentences.(["justin bibier", "and sentences", "are", "allowed"])
# => returns ["justin bibier", "and sentences"]

allowed |> List.first |> censored.() # => returns "****** ******"
```

---

## Composition

---

```javascript
const compose = (...fns) => (...args) => {
  return fns.reduceRight((res, fn) => { 
    return [fn.call(null, ...res)];
  }, args)[0];
}
```

---

```javascript
const toUpperCase = x => x.toUpperCase();
const exclaim = x => `${x}!`;
const shout = compose(exclaim, toUpperCase);

shout('send in the clowns'); // "SEND IN THE CLOWNS!"
```

---

```elixir
defmodule Compose do
  import Curry

  def f <|> g, do: compose(f, g)

  def compose(f, g) when is_function(g) do
    fn arg -> compose(curry(f), curry(g).(arg)) end
  end

  def compose(f, arg) do
    f.(arg)
  end
end
```

---

```elixir
import Compose

to_upper_case = fn x -> String.upcase(x) end
exclaim = fn x -> x <> "!" end
shout = exclaim <|> to_upper_case

shout.('send in the clowns'); # "SEND IN THE CLOWNS!"
```

---

## Types

---

```haskell
data Maybe a = Just a
             | Nothing
```

---

```elixir
defmodule Maybe do
  @type t :: %__MODULE__{
    just: term,
    nothing: boolean
  }
  defstruct just: nil,
            nothing: false

  def just(v), do: __MODULE__ |> struct(just: v)
  def nothing, do: __MODULE__ |> struct(nothing: true)
end
```

---

## Functors

---

```haskell
class Functor f where
    fmap :: (a -> b) -> f a -> f b
```

---

```haskell
instance Functor Maybe where
    fmap _ Nothing  = Nothing
    fmap f (Just a) = Just (f a)
```

---

```javascript
class Container {
  constructor(x) {
    this.$value = x;
  }

  static of(x) {
    return new Container(x);
  }

  map(f) {
    return Container.of(f(this.$value));
  }
}
```

---

```javascript
let append = curry(x, y => y + x)
let prop = curry(key, object => object[key])

Container.of('bombs').map(append(' away')).map(prop('length'));
// Container.of(10)
```

---

```elixir
defprotocol Functor do
  @spec fmap(t, (term -> term)) :: t
  def fmap(functor, fun)
end
```

---

```elixir
defimpl Functor, for: Maybe do
  def fmap(%{nothing: true} = f, _), do: f
  def fmap(%{just: a}, fun) do
    fun
    |> apply([a])
    |> Maybe.just
  end
end
```

---

```elixir
import Compose

trimmed_length = String.length/1 <|> String.trim/1

Maybe.nothing() |> Functor.fmap(trimmed_length)
# %Maybe{nothing: true, just: nil}
```
---

## Monads

```

Confusing?

```

https://wiki.haskell.org/Monad_tutorials_timeline

---

```javascript
class Maybe {
  constructor(x) {
    this.$value = x;
  }

  static of(x) {
    return new Maybe(x);
  }

  isNothing() {
    return (this.$value === null || this.$value === undefined);
  }

  map(f) {
    return this.isNothing() ? Maybe.of(null) : Maybe.of(f(this.$value));
  };
}
```

---

## Applicative

---

```elixir
defprotocol Applicative do
  @spec apply(t, Functor.t) :: t
  def apply(fun, f)
end
```

---

```elixir
defimpl Applicative, for: Maybe do
  def apply(%{nothing: true} = f, _), do: f
  def apply(%{just: fun}, f) do
    f |> Functor.fmap(fun)
  end
end
```

---

# References

https://mostly-adequate.gitbooks.io/mostly-adequate-guide/appendix_a.html
http://blog.patrikstorm.com/function-currying-in-elixir
https://shane.logsdon.io/writing/functors-applicatives-and-monads-in-elixir/
https://www.bignerdranch.com/blog/composing-elixir-functions/

---

# Practice

https://github.com/witchcrafters/witchcraft
