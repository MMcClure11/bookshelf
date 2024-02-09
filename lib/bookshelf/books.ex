defmodule Bookshelf.Books do
  @moduledoc """
  Functions for working with `Bookshelf.Books`.
  """

  alias Bookshelf.Books.Book

  @books "#{File.cwd!()}/priv/books.toml"
  @statuses ["want_to_read", "in_progress", "complete"]

  @doc """
  Decodes the list of books from `Toml` to an elixir list of maps for each
  book.
  """
  @spec list_books() :: keyword()
  def list_books() do
    input = File.read!(@books)
    %{"books" => books} = Toml.decode!(input)
    books
  end

  @doc """
  Transforms the list of books as maps into a list of `Bookshelf.Books.Book`
  structs.
  """
  @spec create_book_structs() :: [Book.t()]
  def create_book_structs() do
    books = list_books()

    Enum.map(books, fn book ->
      book
      |> Map.new(fn {k, v} -> {String.to_existing_atom(k), parse_value(v)} end)
      |> then(&struct!(Book, &1))
    end)
  end

  @spec parse_value(String.t()) :: String.t() | atom()
  defp parse_value(value) when value in @statuses, do: String.to_existing_atom(value)
  defp parse_value(value), do: value
end
