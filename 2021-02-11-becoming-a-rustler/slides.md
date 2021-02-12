# Becoming a Rustler

---

## Why?

```notes
sometimes you want to use code you didn't write
sometimes you need mutible data structures
```

---

There are two ways to execute external code.

---

Ports

https://hexdocs.pm/elixir/1.11.3/Port.html

---

```
iex> path = System.find_executable("echo")
iex> port = Port.open({:spawn_executable, path}, [:binary, args: ["hello world"]])
iex> flush()
{#Port<0.1380>, {:data, "hello world\n"}}
```

---

Nifs

http://erlang.org/doc/man/erl_nif.html

---

Using C code to connect Elixir LiveView to Xbox Kinect

https://dockyard.com/blog/2020/05/11/elixir-nifs-xbox-kinect-and-liveview

---

More day to day oriented

https://blog.discord.com/using-rust-to-scale-elixir-for-11-million-concurrent-users-c6f19fc029d3

---

But why Rust and not C?

---

Thanks Michael

https://andrealeopardi.com/posts/using-c-from-elixir-with-nifs/

---

Only two ways you can crash the Erlang VM

* Atoms
* Nifs

```notes
The safety gaurantees of Rust make it a good fit for a Nif
```

---

Still have to be careful with Rust

```
unsafe { }
```

```notes
once you type unsafe you might as well be writing C
```

---

Personal Opinion:
"You should explore every option before reaching for external tools."

---

Phoenix used sharding strategies to communicate to 2 millions persistent web sockets in 1 second.

---

OK, Let's setup a Rustler project

---

Let's actually crash Elixir!

https://hambly.dev/rust-nifs-in-elixir.html

---

```
#[rustler::nif]
fn panic() {
    panic!("Boom!")
}

rustler::init!("Elixir.MyNif", [add, panic]);
```

```
def panic(), do: :erlang.nif_error(:nif_not_loaded)
```

---

```
#[rustler::nif]
fn crash() {
    let p: *const i32 = std::ptr::null();
    unsafe {
        println!("{:?}", *p);
    }
}

rustler::init!("Elixir.MyNif", [add, panic, crash]);
```

```
def crash(), do: :erlang.nif_error(:nif_not_loaded)
```

---

Rustler has a great example application:

https://github.com/rusterlium/NifIo
