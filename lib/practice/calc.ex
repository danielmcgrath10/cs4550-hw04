defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def getPrec(char) do 
    cond do 
      char == "+" || char == "-" -> 
        1
      char == "*" || char == "/" ->
        2
      char == "^" ->
        3
      true -> 
        0
    end
  end

  def checkOp(_prevOp, curOp, operators, postfix, check1, check2, ops) when check1 <= check2 do
    inPos(ops -- [curOp], postfix, [curOp | operators])
  end

  def checkOp(prevOp, curOp, operators, postfix, _check1, _check2, ops) do
    if Enum.empty?(operators) do
      inPos(ops -- [curOp], postfix, [curOp | operators])
    else
      checkOp(prevOp, curOp, operators -- [prevOp], postfix ++ [prevOp], getPrec(prevOp), getPrec(curOp), ops)
    end
  end

  def inPos(ops, postfix, operators) do
    if Enum.empty?(ops) do
      postfix ++ operators
    else
      curOp = Enum.at(ops, 0)
      if String.match?(curOp, ~r/[-+\/*]/) do
        prevOp = Enum.at(operators, 0)
        checkOp(prevOp, curOp, operators, postfix, getPrec(prevOp), getPrec(curOp), ops)
      else
        inPos(ops -- [curOp], postfix ++ [curOp], operators)
      end
    end
  end

  def toPre(expr, prefix, nums) do
    if length(expr) <= 1 do 
      prefix
    else
      val = Enum.at(expr, 0)
      if String.match?(val, ~r/[-+\/*]/) do
        toPre(expr -- [val], prefix ++ [val, Enum.at(nums, 0), Enum.at(nums,1)], nums -- [Enum.at(nums, 0), Enum.at(nums,1)])
      else
        toPre(expr -- [val], prefix, [val | nums])
      end
    end
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    postfix = []
    operators = []
    ops = expr
    |> String.split(~r/\s+/)
    # |> Enum.map(fn(a) ->
    #   IO.inspect a
    #   cond do
    #     String.match?(a, ~r/[-+\/*]/) ->
    #       {:op, a}
    #     String.match?(a, ~r/[0-9]+/) ->
    #       {:num, a}
    #   end
    # end)
    |> IO.inspect

    postFix = inPos(ops, postfix, operators)
    |> IO.inspect

    prefix = []
    nums = []
    preFix = toPre(postFix, prefix, nums)
    |> IO.inspect
    |> hd
    |> parse_float
    |> :math.sqrt()

    # if !Regex.match?( ~r/[^+-\/*]||[a-zA-Z]/, expr) do
    #   expr |> Code.eval_string |> elem(0)
    # else
    #   false
    # end

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