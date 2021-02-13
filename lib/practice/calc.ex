# Got inspiration for this from GeeksforGeeks  
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
    if Enum.empty?(expr) do 
      Enum.join(Enum.reverse(prefix), " ")
    else
      val = Enum.at(expr, 0)
      if String.match?(val, ~r/[-+\/*]/) do
        if Enum.empty?(nums) do
          toPre(expr -- [val], (prefix -- [Enum.at(prefix, 0),Enum.at(prefix,1)]) ++ [Enum.join([val,Enum.at(prefix, 0),Enum.at(prefix,1)]," ")], nums)
        else
          toPre(expr -- [val], prefix ++ [Enum.join([val,Enum.at(nums, 1),Enum.at(nums,0)]," ")], nums -- [Enum.at(nums, 0), Enum.at(nums,1)])
        end
      else
        toPre(expr -- [val], prefix, [val | nums])
      end
    end
  end

  def doMath(opr, op1, op2) do
    {op1, _} = Float.parse(op1)
    {op2, _} = Float.parse(op2)
    cond do
      opr == "+" -> 
        Float.to_string(op1 + op2)
      opr == "-" -> 
        Float.to_string(op1 - op2)
      opr == "*" -> 
        Float.to_string(op1 * op2)
      opr == "/" -> 
        Float.to_string(op1 / op2)
    end
  end

  def evaluate(prefix, stack) do
    if Enum.empty?(prefix) do
     Enum.at(stack, 0) 
    else
      val = Enum.at(prefix, 0)
      if String.match?(val, ~r/[-+\/*]/) do
        if Enum.empty?(stack) do
          evaluate(prefix -- [val, Enum.at(prefix, 1), Enum.at(prefix, 2)], [doMath(val, Enum.at(prefix, 1), Enum.at(prefix, 2)) | stack])
        else
          evaluate(prefix -- [val], [doMath(val, Enum.at(stack, 0), Enum.at(stack, 1)) | stack -- [Enum.at(stack, 0), Enum.at(stack, 1)]])
        end
      else
        evaluate(prefix -- [val], [val | stack])
      end
    end
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    if String.match?(expr, ~r/[-+\/*]/) do
      postfix = []
      operators = []
      prefix = []
      nums = []
      stack = []
      ops = expr
      |> String.split(~r/\s+/)
      |> inPos(postfix, operators)
      |> toPre(prefix, nums)
      |> String.split(~r/\s+/)
      
      eval = evaluate(Enum.reverse(ops), stack)
      {eval, _} = Float.parse(eval)
      eval
    else
      {expr, _} = Float.parse(expr)
      expr
    end
  end
end
[]