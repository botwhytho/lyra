defmodule ModularProperty do
  use ExUnit.Case
  use EQC.ExUnit

  @norm round(:math.pow(2, 160))

  property "set membership under modular interval arithmetic correct" do
    forall {u, v} <- bounds() do
      forall x <- point() do
        ensure Skip.Modular.epsilon?(x, include: u, exclude: v) == correct(x, u, v)
      end
    end
  end

  ## Our Model.

  defp correct(x, u, v) when u < v do
    between?(x, include: u, exclude: v)
  end
  defp correct(_, u, v) when u === v do
    true
  end
  defp correct(x, u, v) when u > v do
    between?(x, include: u, exclude: biggest()) or between?(x, include: 0, exclude: v)
  end

  ## Test Ancillaries.

  defp bounds do
    {bound(), bound()}
  end

  defp bound do
    natural()
  end

  defp point do
    natural()
  end

  defp natural do
    let i <- largeint() do
      if i < biggest(), do: positive(i)
    end
  end

  defp positive(x) when x < 0, do: -1 * x
  defp positive(x) when x >= 0, do: x

  defp between?(x, [include: start, exclude: stop]) do
    start <= x and x < stop
  end

  def biggest do
    @norm
  end
end