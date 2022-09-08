# Elixirconf in Review

---

Welcome!

---

First and foremost

---

I'm sorry, I thought the videos would be out by now

---

* Keynotes
* Must Watch (Eventually)
* Worth Noteing

---

# Keynotes

---

José Valim

## Happy 10 years of Elixir!

---

## Elixir 1.14

https://elixir-lang.org/blog/2022/09/01/elixir-v1-14-0-released/

* dbg
* PartitionSupervisor
* Expression and order-based inspection
* Improved error messages for binaries

---

## Elixir Roadmap

* Set theoretic types
* Developer and learning experience
* Machine Learning

---

### Set theoretic types

Go back and watch Elixirconf EU talk on Elixir type system

https://www.youtube.com/watch?v=Jf5Hsa1KOc8

---

### Developer and learning experience

New kino functions to allow learning in LiveBook

---

### Machine Learning

* Explorer
* Nx
* Axon
* EXLA Torchx

---

### Two talks about ML at conference covering:

* Axon: Functional Programming for Deep Learning 
  - Sean Moriarity
* The New AI Stack: Why we're betting on an all Elixir future from ETL to deep learning 
  - Chris Grainger

---

Brian Cardarella

## Dockyard Keynote

* https://github.com/BeaconCMS/beacon
* https://getfirefly.org
* https://academy.dockyard.com
* https://native.live

---

### LiveView Native 

* iOS
* MacOS
* tvOS
* WatchOS

---

Because it becomes native swift you use all of the existing SwiftUI comonenets just they are lower cased and dasherized.

```
<vstack>
  <text><%= @counter %></text>
  <hstack>
    <button phx-click="increment_counter" buttons-style="bordered-prominent" tint="system-teal">
      <text>+1</text>
    </button>
    <button phx-click="decrement_counter" buttons-style="bordered-prominent" tint="system-red">
      <text>-1</text>
    </button>
  </hstack>
</vstack>
```

---

### LiveView Native Roadmap

* Android (Jetpack Compose)
* Windows (WinUI3)
* Unity (C# only)

---

Chris McCord

## Phoenix 1.17

* Verified Routes
* Declarative assigns and slots
* Heex formatting
* `phx.gen.auth --live`
* tailwind by default
* liveview accessibility
* tailwind heex components out of the box

---

### Verified Routes

```elixir
~p"/posts/#{@post.id()}/comments?page=#{@page}"
```

warnings and syntax highlighting

---

### Declarative assigns and slots

```elixir
# in liveview
attr :row_id, :any, default: nil, "represents the row id"

slot :foo, ...
```

---

### LiveView Accessibility

```elixir
<.focus_wrap>
  ...
</.focus_wrap>
```

---

## Phoenix Roadmap

* Storybook 
  - Christian Blavier's work https://github.com/phenixdigital/phx_live_storybook
* Streams for optimized collections
* Unified LiveView/LiveComponent messenging
* Re-imagined form API
* Function component template files
* <.layout>

---

# Must Watch

---

Kip Cole

## Time Algebra

https://github.com/kipcole9/tempo

https://github.com/kipcole9/tempo/blob/main/test/tempo/enumeration_test.exs#L147-L168

---

Justin Wood

## Introduction to query debugging and optimization in Postgres

Nothing to do with Elixir but a great intro to optimizing postgres

---

# Worth Noteing

---

Chris Keele

## Match Specs

https://www.erlang.org/doc/apps/erts/match_spec.html

---

Owen Bickford

### WebAuthnLive Component

https://github.com/liveshowy/webauthn_live_component
https://github.com/liveshowy/webauthn_live_component_demo

---

Caching with PG WAL

---

cars.com moved to elixir

---

Flame On - Mike Binns

https://github.com/DockYard/flame_on

---

Lighting Talks

Surreal Numbers

ASH 2.0
https://github.com/ash-project/ash

Diamond
https://github.com/outstand/diamond

Guy built a flight simulator in liveview and one a hackathon

RBAC for liveviews
* live_session on_mount calls authorization module

Maintain multiple elixir apps in a single code base
github.com/ucbi/uniform
