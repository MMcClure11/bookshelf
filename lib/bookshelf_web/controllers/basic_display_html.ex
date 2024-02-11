defmodule BookshelfWeb.BasicDisplayHTML do
  use BookshelfWeb, :html

  def index(assigns) do
    ~H"""
    <h1 class="text-xl font-bold text-slate-900 px-2 py-4">The Bookshelf</h1>
    <table class="border-separate border-spacing-1 border border-slate-500 bg-slate-800">
      <thead>
        <tr>
          <.column_header text="Title" />
          <.column_header text="Author" />
          <.column_header text="Genre" />
          <.column_header text="Status" />
          <.column_header text="Review" />
          <.column_header text="Date Read" />
        </tr>
      </thead>
      <tbody>
        <%= for book <- @books do %>
          <tr>
            <.cell_data value={book.title} class="text-center" />
            <.cell_data value={book.author} class="text-center" />
            <.cell_data value={book.genre} class="text-center" />
            <.cell_data value={parse_status(book.status)} class="text-center" />
            <.cell_data value={book.review} class="whitespace-pre-line" />
            <.cell_data value={book.date_read} class="text-center" />
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  attr :text, :string, required: true

  defp column_header(assigns) do
    ~H"""
    <th class="border border-slate-600 p-2 text-slate-100 bg-slate-500"><%= @text %></th>
    """
  end

  attr :value, :string, required: true
  attr :class, :string, default: ""

  defp cell_data(assigns) do
    ~H"""
    <td class={["border border-slate-700 text-slate-200 bg-slate-600 p-2", @class]}>
      <%= @value %>
    </td>
    """
  end

  @spec parse_status(:want_to_read | :in_progress | :complete) :: String.t()
  defp parse_status(:want_to_read), do: "Want to read"
  defp parse_status(:in_progress), do: "In progress…"
  defp parse_status(:complete), do: "Complete"
end
