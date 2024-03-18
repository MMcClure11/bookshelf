defmodule Bookshelf.Books.Details do
  @moduledoc """
  A struct for presenting `Bookshelf.Books.Book` details.
  """

  alias Bookshelf.Books.Book

  @type t() :: %__MODULE__{
          author: String.t(),
          cover_art: String.t(),
          date_read: Date.t(),
          review: [String.t()],
          status: Book.status(),
          title: String.t()
        }

  defstruct author: nil,
            cover_art: nil,
            date_read: nil,
            review: nil,
            status: nil,
            title: nil
end
