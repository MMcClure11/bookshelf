defmodule Bookshelf.Books do
  @moduledoc """
  Functions for working with `Bookshelf.Books`.
  """

  alias Bookshelf.Books.Book
  alias Bookshelf.Books.Details

  @doc """
  Decodes a list of books from [TOML](https://toml.io/) to a list of maps.
  """
  @spec list_books() :: keyword()
  def list_books() do
    input = File.read!(data_path())
    %{"books" => books} = Toml.decode!(input)
    books
  end

  @spec data_path() :: String.t()
  defp data_path() do
    case System.get_env("PHX_HOST") do
      "bookshelf-meks.fly.dev" -> "/books.toml"
      _ -> "#{File.cwd!()}/priv/books.toml"
    end
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

  @doc """
  Returns a list of `Bookshelf.Books.Book`s where the given string is found in
  the `:title` or `:author` field.
  """
  @spec filter_books(String.t()) :: [Book.t()]
  def filter_books(search_query) do
    books = create_book_structs()

    Enum.filter(
      books,
      fn book ->
        check_match(book, :title, search_query) || check_match(book, :author, search_query)
      end
    )
  end

  @spec check_match(Book.t(), :author | :title, String.t()) :: boolean()
  defp check_match(book, key, search_query) do
    book
    |> Map.get(key)
    |> String.downcase()
    |> String.contains?(String.downcase(search_query))
  end

  @doc """
  Given a string returns a single `Bookshelf.Books.Details` with a matching `:title`.
  """
  @spec get_book_details(String.t()) :: Details.t()
  def get_book_details(title) do
    book = create_book_structs() |> Enum.filter(&(&1.title == title)) |> hd()

    struct(Details, %{
      author: book.author,
      cover_art: book.cover_art,
      date_read: book.date_read,
      review: book.review,
      status: book.status,
      title: book.title
    })
  end
end
