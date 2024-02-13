defmodule Bookshelf.Books.Book do
  @moduledoc """
  A struct for modeling a `Bookshelf.Books.Book`.
  """

  @type t() :: %__MODULE__{
          title: String.t(),
          author: String.t(),
          genre: String.t(),
          status: :want_to_read | :in_progress | :complete,
          review: [String.t()],
          date_read: Date.t(),
          cover_art: String.t()
        }

  @enforce_keys [:title, :author, :genre, :status]

  defstruct @enforce_keys ++ [:review, :date_read, :cover_art]
end
