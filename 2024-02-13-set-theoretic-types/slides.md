---
layout: cover
---

# Set-Theoretic Types

---
layout: center
---

# What do types give us?

[ElixirConf 2023 - José Valim - The foundations of the Elixir type system](https://www.youtube.com/watch?v=giYbq4HmfGA)

---
layout: center
---

# Less tests? No
```elixir
$ list((number()) -> number()
def average(list) do
  Enum.random(list)
end
```

---
layout: center
---

# Less bugs? No

For instance Rust's type system can prevent the following:

1. Deallocating memory twice
2. Using deallocated memory
3. Data races in threads
4. Dangling pointers
5. ....

These problems do not exist in Elixir

---
layout: center
---

# Performance? No

Elixir runs on the Beam VM

---
layout: center
---

# What do types even give us?

1. Documentation
2. Useful as a design tool
3. As proof of correctness

---
layout: center
---

# Types as proof of correctness

---
layout: center
---

# How would you type this function?

```elixir
def negate(int) when is_integer(int) do
  -int
end

def negate(bool) when is_boolean(bool) do
  not bool
end
```

---
layout: center
---


# Naive approach
```elixir
$ (integer() or boolean()) -> (integer() or boolean())
def negate(int) when is_integer(int) do
  -int
end

def negate(bool) when is_boolean(bool) do
  not bool
end
```

Passes but is not correct

You might think it's not correct because

```elixir
# integer() -> integer()
# boolean() -> boolean()
# integer() -> boolean()
# boolean() -> integer()
```

---
layout: center
---
```elixir
$ integer(), integer() -> integer()
def subtract(a, b) do
  a + negate(b) # type error `+/2` cannot be applied to boolean()
  # negate/1 returns integer() | boolean()
end
```

---
layout: center
---

# Dialyzer

```elixir
# current dialyzer type spec
@spec negate(integer() | boolean()) :: integer() | boolean()
def negate(int) when is_integer(int) do
  -int
end

def negate(bool) when is_boolean(bool) do
  not bool
end
```

---
layout: center
---

# We need a better type system

Set-theoretic types describe types as sets of unions and intersections

So thinking about a function as a set of definitions what would go here?
```elixir
$ integer() -> integer() *???????* boolean() -> boolean()
```

---
layout: center
---

# Also not correct

```elixir
$ integer() -> integer() or boolean() -> boolean()
def negate(int) when is_integer(int) do
  -int
end

# other function head deleted but still passes
```

---
layout: center
---

# Set-theoretic type
```elixir
$ integer() -> integer() and boolean() -> boolean()
def negate(int) when is_integer(int) do
  -int
end

def negate(bool) when is_boolean(bool) do
  not bool
end
```

---
layout: center
---

# Gradual typing

* Introduces a new type `dynamic()`
* If no type is declared the type is `dynamic()`
* `dynamic()` is a known at runtime
* If `dynamic()` is not used the system becomes static
* Existing code keeps working
* No big bang version change

 (not inference but a system with both typed and untyped code)


---
layout: center
---

# if you don't add a type signature than the type is dynamic()

```elixir
# Imagine the compiler adding this type
$ dynamic(), dynamic() -> dynamic()
def some_fun(a, b) do
  some_other_fun(a, b)
end
```

---
layout: center
---

# Gradual typing rules

1. When a type is specified the type system becomes static
2. The more dynamic() is used the few guarantees the type system can give

---
layout: center
---

# Strong Arrows

1. If a function a -> b
2. We negate the domain (a) and type check
3. If that errors then it is a strong arrow

Proves that if we call the function with something outside the domain then the
type will error.

If you call a strong arrow with dynamic() type it is guaranteed to return it's
type.

Type checking of dynamic can be done at compile time even though it's type is
only known at runtime.

---
layout: center
---

Compile time and runtime checks with no additional runtime overhead!
```elixir
$ integer() -> integer()
def identity(arg) when is_integer(arg) do
  arg
end

# compile time error
# dynamic() -> error!
def debug(arg) do
  "we got: " <> identity(arg)
end

# runtime error
iex> debug("foo")
** (FunctionClauseError) no function clause matching ...
```

---
layout: center
---

# Strong Arrows are transitive

Once a function is typed it's type spreads to the dynamic type of other functions


---
layout: center
---

# Type inference

Looks at pattern and guards

---
layout: center
---

# Gradual set-theoretic types

* Express many of Elixir idioms with precision
* Provide a simple foundation for reasoning about code
* Allows interaction between static and dynamic code
* Taming the dynamic type:
    1. Strong arrows have no additional runtime checks
    2. Type inference is based on patterns and guards

---
layout: center
---

# Elixir 1.18

* Type inference of patterns (typing inference of guards will be part of an upcoming release)
* Type checking of all language constructs, including local and remote calls, except for, with, and closures
* Type checking of all functions inlined by the compiler found in Kernel
* Type checking of all conversion functions inlined by the compiler
* Support for tuples and lists as composite types as well as type checking of their basic operations
* Detection of clauses and patterns that will never match from case, cond, and =
* Detection of unused clauses in private functions

---
layout: center
---

# Elixir 1.19 (June 2025)

* More type inference
* Type checking protocol dispatch and implementations

---
layout: center
---

# Elixir 1.20 (December 2025)

* Ability to statically type Elixir code
