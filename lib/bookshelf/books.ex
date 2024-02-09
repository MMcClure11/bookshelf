defmodule Bookshelf.Books do
  @moduledoc """
  Functions for working with `Bookshelf.Books`.
  """

  alias Bookshelf.Books.Book

  @books "#{File.cwd!()}/priv/books.toml"

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
      fields =
        Enum.reduce(
          [:title, :author, :genre, :status, :date_read, :review, :cover_art],
          [],
          fn field, acc ->
            if field == :status do
              acc ++ ["#{field}": book |> Map.get(to_string(field)) |> String.to_existing_atom()]
            else
              acc ++ ["#{field}": Map.get(book, to_string(field))]
            end
          end
        )

      struct!(Book, fields)
    end)
  end
end
