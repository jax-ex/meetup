defmodule MyType do
  defstruct [:name, :age]
  #
  defmodule User do
    defstruct [:age, :car_choice]

    def drive(%User{age: age, car_choice: car}, car_choices) when age >= 18 do
      if car in car_choices do
        {:ok, car}
      else
        {:error, :no_choice}
      end
    end

    def drive(%User{}, _car_choices) do
      {:error, :not_allowed}
    end
  end

  # def public(x) do
  #   private(Integer.parse(x)) # {int, rest} | :error
  # end
  #
  # defp private(nil), do: nil
  # defp private("foo"), do: "foo"
  # defp private({int, _rest}), do: int
  # defp private(:error), do: 0
  # defp private("bar"), do: "bar"

  # def set_name(%MyType{} = myType) do
  #   %{myType | naem: "new name"}
  # end

  # def compare_dates(%Date{} = date1, %Date{} = date2) do
  #   date1 > date2
  # end

  #
  # def drive(car_choices) do
  #   {:ok, %User{}}
  #   |> User.drive(car_choices)
  # end

  def drive2(user, car_choices) do
    case User.drive(user, car_choices) do
      {:ok, car} -> car
      :error -> IO.puts("User cannot drive")
    end
  end
end
