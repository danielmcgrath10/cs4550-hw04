defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    # expr
    # |> String.split(~r/\s+/)
    # |> Enum.map(fn(a, i) -> 
    #   if String.match(a, ~r/-+\/*/) do
    #     {:op, a}
    #   else if String.match(a, ~r/[0-9]+/) do
    #     {:num, a}
    #   end
    # end)
    # |> hd
    # |> parse_float
    # |> :math.sqrt()
    if !Regex.match?( ~r/[^+-\/*]||[a-zA-Z]/, expr) do
      expr |> Code.eval_string |> elem(0)
    else
      false
    end
    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end
end
[]