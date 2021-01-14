# "What can Elixir do that Go can't?"

```notes
asked by a co-worker
set me on a journey to answer some questions
why is it that I advocate so hard for elixir?
what makes elixir different?
```

---

This is not a talk slamming Go or any other language.

```notes
most developers today must be polyglots
```

---

# Elixir isn't Ruby

```notes
another title
```

---

# What makes Elixir different

```notes
what we're here to talk about
maybe should have been the title
```
---

But the title isn't important

```notes
what's imporantant is what Elixir gives us
```

---

But first...

What do programming languages give us?

---

```
10110000 01100001
```

```notes
5 bit instruction
3 bit register address
8 bit data
```
---

```
MOV AL, 61h       ; Load AL with 97 decimal (61 hex)
```

```notes
what can elixir do that assembly language can't?
```

---

## Abstractions

---

Lambda Calculus

```
x
(λx.M)
(M N)
```

---

Loop

```
λ⨍.(λx.⨍(x x))(λx.⨍(x x))
```

```notes
simple doesn't mean it's easy
```
---

the best programming languages give us tools to balance the concrete and the abstract

---

Elixir borrows good things from Erlang, Clojure and Ruby and adds to them

---

https://dashbit.co/blog/ten-years-ish-of-elixir

---

# Erlang
 
---

## High Availability

soft real time

---

How do you build a system that doesn't crash?

```notes
study about systems and restarts
telephone machines that restart quickly
```

---


Make hundreds/thousands/millions of tiny machines (programs) that communicate with each other.

```
spawn(fn -> 1 + 2 end)
```

```notes
each program has it's own garbage collector
performance is linear and predictible
elixir plays nice with k8's and heroku
```
---

Allow the exceptions of one process to be handled as communication to another

```notes
usually exceptions are handled outside of the process that is in a bad state
```

---

```
iex(1)> Process.flag(:trap_exit, true)
false
iex(2)> spawn_link(fn -> raise "oops" end)
#PID<0.109.0>
iex(3)> receive do
...(3)>   {:EXIT, _from, _reason} -> IO.puts("logging")
...(3)> end
logging
:ok
```

---

Erlang arrived in 1986
Multicore support was added in 2006

```notes
concurrecy was needed
mulitcore was a side effect of the way isolated processes work
```

---

pre-emptive scheduler

---

no shared memory

---

immutible data structures

---

tail call optimization

---

functional language

---

```
def count([]), do: 0
def count([_x|xs]), do: 1 + count(xs)

```

---

## more needed for high availability

---

hot code reload

https://dev.to/appsignal/hot-code-reloading-in-elixir-6ei

---

disributed systems


```notes
message passing between systems
erlang messages don't marshal
```

---

consistent and predictible performance
https://stressgrid.com/blog/benchmarking_go_vs_node_vs_elixir/

---

# Open Telecom Platform (OTP)

batteries included

---

genserver
supervisors
genstate
ets
nmesia

---

debugging tools

```
:observer.start()
```

https://elixir-lang.org/getting-started/debugging.html

---

optional type system

```
defmodule LousyCalculator do
  @typedoc """
  Just a number followed by a string.
  """
  @type number_with_remark :: {number, String.t}

  @spec add(number, number) :: number_with_remark
  def add(x, y), do: {x + y, "You need a calculator to do that?"}

  @spec multiply(number, number) :: number_with_remark
  def multiply(x, y), do: {x * y, "It is like addition on steroids."}
end
```

---

# Clojure

---

hygenic compile time macros

```
iex> quote do: 1 + 2
{:+, [context: Elixir, import: Kernel], [1, 2]}
iex> quote do: if value, do: "True", else: "False"
{:if, [context: Elixir, import: Kernel],
 [{:value, [], Elixir}, [do: "True", else: "False"]]}
```

```notes
homoiconic
```

---

polymorphism
protocols


NOTE: FIX THIS

```
defimpl Jason.Encoder, for: URL do
  def encode(%URL{} = url) do
    Jason.string(to_string(url))
  end
end
```

---

https://github.com/jarednorman/canada

---

```
defimpl Canada.Can, for: User do
  def can?(%User{id: user_id}, action, %Post{user_id: user_id})
    when action in [:update, :read, :destroy, :touch], do: true

  def can?(%User{admin: admin}, action, _)
    when action in [:update, :read, :destroy, :touch], do: admin

  def can?(%User{}, :create, Post), do: true
end
```

---

```
import Canada, only: [can?: 2]

if current_user |> can? read(some_post) do
  #...
end
```

---

```
defmodule Canada do
  defmacro can?(subject, {action, _, [argument]}) do
    quote do
      Canada.Can.can? unquote(subject), unquote(action), unquote(argument)
    end
  end
end

```

---

```
defprotocol Canada.Can do
  @fallback_to_any true

  @doc "Evaluates permissions"
  def can?(subject, action, resource)
end
```

---

# Ruby

---

a little syntax

---

sigils

```
iex> ~s({"age":44,"name":"Steve Irwin","nationality":"Australian"})
"{\"age\":44,\"name\":\"Steve Irwin\",\"nationality\":\"Australian\"}"

iex> ~j'{"name": "Micah"}'a
%{name: "Micah"}
```

---

a big focus on productivity

---

https://preslav.me/2020/09/06/elixir-is-not-ruby-elixir-is-erlang/

# Elixir

---

mix

```notes
application structure
dependency managment
task runner
```

---

umbrella apps

---

genstage
https://blog.discord.com/how-discord-handles-push-request-bursts-of-over-a-million-per-minute-with-elixirs-genstage-8f899f0221b4
https://github.com/elixir-lang/gen_stage

---

phoenix
https://www.phoenixframework.org

---

ecto
https://github.com/elixir-ecto/ecto

---

rustler
https://blog.discord.com/using-rust-to-scale-elixir-for-11-million-concurrent-users-c6f19fc029d3G
https://github.com/discord/sorted_set_nif
https://github.com/rusterlium/rustler

---

so much more...

---

Jax.Ex this year

---

## workshops

rustler

---

## bookclub

ocaml
https://dev.realworldocaml.org/index.html

liveview ($99)
https://pragmaticstudio.com/phoenix-liveview


---

slides
https://github.com/jax-ex/meetup
