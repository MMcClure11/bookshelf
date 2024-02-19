defmodule BookshelfWeb.BasicDisplayHTML do
  use BookshelfWeb, :html

  def index(assigns) do
    ~H"""
    <h1 class="px-2 py-4 text-xl font-bold text-slate-900">The Bookshelf</h1>
    <div class="py-2">
      <%= Phoenix.HTML.Tag.form_tag("/", method: "post") do %>
        <input
          type="text"
          name="query"
          value={@query}
          placeholder="Search by Title or Author"
          class="border border-slate-600 bg-slate-200 text-slate-600"
        />
        <input
          type="submit"
          class="cursor-pointer border border-slate-600 bg-slate-500 p-2 font-semibold text-slate-200"
          value="Search"
        />
      <% end %>
    </div>
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
          <tr class="text-center">
            <.cell_data><%= book.title %></.cell_data>
            <.cell_data><%= book.author %></.cell_data>
            <.cell_data><%= book.genre %></.cell_data>
            <.cell_data><%= parse_status(book.status) %></.cell_data>
            <.cell_data><.review value={book.review} /></.cell_data>
            <.cell_data><%= book.date_read %></.cell_data>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  attr :text, :string, required: true

  defp column_header(assigns) do
    ~H"""
    <th class="border border-slate-600 bg-slate-500 p-2 text-slate-100"><%= @text %></th>
    """
  end

  slot :inner_block

  defp cell_data(assigns) do
    ~H"""
    <td class="border border-slate-700 bg-slate-600 p-2 text-slate-200">
      <%= render_slot(@inner_block) %>
    </td>
    """
  end

  attr :value, :list, required: true

  defp review(%{value: nil} = assigns), do: ~H""

  defp review(assigns) do
    ~H"""
    <%= for item <- @value do %>
      <p class="mb-2 text-left last:mb-0"><%= item %></p>
    <% end %>
    """
  end

  @spec parse_status(:want_to_read | :in_progress | :complete) :: String.t()
  defp parse_status(:want_to_read), do: "Want to read"
  defp parse_status(:in_progress), do: "In progress…"
  defp parse_status(:complete), do: "Complete"
end
