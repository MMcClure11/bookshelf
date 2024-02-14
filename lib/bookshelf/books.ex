defmodule Bookshelf.Books do
  @moduledoc """
  Functions for working with `Bookshelf.Books`.
  """

  alias Bookshelf.Books.Book

  @books "#{File.cwd!()}/priv/books.toml"

  @doc """
  Decodes a list of books from [TOML](https://toml.io/) to a list of maps.
  """
  @spec list_books() :: keyword()
  def list_books() do
    input = File.read!(@books)
    %{"books" => books} = Toml.decode!(input)
    books
  end

  @doc """
  Transforms a list of books as maps into a list of `Bookshelf.Books.Book`s.
  """
  @spec create_book_structs() :: [Book.t()]
  def create_book_structs() do
    books = list_books()

    Enum.map(books, fn book ->
      book
      |> Map.new(fn {k, v} -> {parse_key(k), parse_value(k, v)} end)
      |> then(&struct!(Book, &1))
    end)
  end

  @spec parse_key(String.t()) :: atom()
  defp parse_key("title"), do: :title
  defp parse_key("author"), do: :author
  defp parse_key("genre"), do: :genre
  defp parse_key("status"), do: :status
  defp parse_key("review"), do: :review
  defp parse_key("date_read"), do: :date_read
  defp parse_key("cover_art"), do: :cover_art

  @spec parse_value(String.t(), String.t()) :: String.t() | atom() | [String.t()]
  defp parse_value("status", value), do: parse_status(value)
  defp parse_value("review", value), do: String.split(value, "\n\n")
  defp parse_value(_, value), do: value

  @spec parse_status(String.t()) :: atom()
  defp parse_status("want_to_read"), do: :want_to_read
  defp parse_status("in_progress"), do: :in_progress
  defp parse_status("complete"), do: :complete
end
