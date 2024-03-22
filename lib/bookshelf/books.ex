defmodule Bookshelf.Books do
  @moduledoc """
  Functions for working with `Bookshelf.Books`.
  """

  alias Bookshelf.Books.Book
  alias Bookshelf.Books.Details
  alias Bookshelf.Repo

  @doc """
  Returns a list of `Bookshelf.Books.Book`s from the in-memory `Bookshelf.Repo`.
  """
  @spec list_books() :: [Book.t()]
  def list_books() do
    Repo.list_books()
  end

  @doc """
  Returns a list of `Bookshelf.Books.Book`s where the given string is found in
  the `:title` or `:author` field.
  """
  @spec filter_books(String.t()) :: [Book.t()]
  def filter_books(search_query) do
    books = list_books()

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
    book = list_books() |> Enum.filter(&(&1.title == title)) |> hd()

    %Details{
      author: book.author,
      cover_art: book.cover_art,
      date_read: book.date_read,
      review: book.review,
      status: book.status,
      title: book.title
    }
  end
end
