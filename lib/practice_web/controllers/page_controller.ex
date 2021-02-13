defmodule PracticeWeb.PageController do
  use PracticeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def double(conn, %{"x" => x}) do
    {x, _} = Integer.parse(x)
    y = Practice.double(x)
    render conn, "double.html", x: x, y: y
  end

  def calc(conn, %{"expr" => expr}) do
    y = Practice.calc(expr)
    render conn, "calc.html", expr: expr, y: y
  end

  def factor(conn, %{"x" => x}) do
    {x, _} = Integer.parse(x)
    y = Enum.at(Enum.reverse(Practice.factor(x)), 0)
    render conn, "factor.html", x: x, y: y
  end

  def palindrome(conn, %{"word" => word}) do
    y = Practice.palindrome(word)
    render conn, "palindrome.html", word: word, y: y
  end
end
