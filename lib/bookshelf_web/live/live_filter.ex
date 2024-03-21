defmodule BookshelfWeb.LiveFilterLive do
  @moduledoc false

  use BookshelfWeb, :live_view

  alias Bookshelf.Books

  @impl Phoenix.LiveView
  def mount(_, _, socket) do
    {:ok, assign(socket, :books, Books.list_books())}
  end

  @impl Phoenix.LiveView
  def handle_event("change", %{"search" => %{"query" => query}}, socket) do
    {:noreply, assign(socket, :books, Books.filter_books(query))}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1 class="text-dragonhide-100 pb-6 font-['Kalnia'] text-[2rem] font-semibold leading-none">
      The Bookshelf
    </h1>

    <form action="" novalidate="" role="search" phx-change="change" class="mb-16">
      <div class="relative">
        <input
          id="search-input"
          name="search[query]"
          type="text"
          class="bg-dragonhide-200 placeholder:text-dragonhide-400 text-dragonhide-600 focus:ring-dragonhide-300 h-12 w-80 rounded-sm border-none indent-10 text-base leading-none tracking-normal"
          placeholder="Type to filter…"
        />
        <div class="bg-dragonhide-300 pointer-events-none absolute inset-y-0 flex w-11 items-center justify-center rounded-bl-sm rounded-tl-sm">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="#594544"
            class="h-5 w-5"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"
            />
          </svg>
        </div>
      </div>
    </form>

    <table class="w-full table-fixed text-left">
      <thead>
        <tr class="text-dragonhide-100 bg-dragonhide-800 text-xs font-bold uppercase leading-none tracking-wider">
          <.column_header text="Title" />
          <.column_header text="Author" />
          <.column_header text="Genre" />
          <.column_header text="Review" />
          <.column_header text="Status/Date Read" />
        </tr>
      </thead>
      <tbody>
        <%= for book <- @books do %>
          <tr class="text-dragonhide-100 bg-dragonhide-400 odd:bg-dragonhide-500 font-serif text-sm leading-normal">
            <.cell_data><%= book.title %></.cell_data>
            <.cell_data><%= book.author %></.cell_data>
            <.cell_data><%= book.genre %></.cell_data>
            <.cell_data class="font-sans text-xs leading-snug">
              <.review value={book.review} />
            </.cell_data>
            <.cell_data><%= parse_status_and_date_read(book) %></.cell_data>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  attr :text, :string, required: true

  defp column_header(assigns) do
    ~H"""
    <th class="p-4"><%= @text %></th>
    """
  end

  attr :class, :string, default: ""
  slot :inner_block

  defp cell_data(assigns) do
    ~H"""
    <td class={["p-4", @class]}>
      <%= render_slot(@inner_block) %>
    </td>
    """
  end

  attr :value, :list, required: true

  defp review(%{value: nil} = assigns) do
    ~H"""
    <p>— —</p>
    """
  end

  defp review(assigns) do
    ~H"""
    <%= for item <- @value do %>
      <p class="mb-2 last:mb-0"><%= item %></p>
    <% end %>
    """
  end

  @spec parse_status_and_date_read(Bookshelf.Books.Book.t()) :: String.t()
  defp parse_status_and_date_read(%{status: :want_to_read}), do: "Want to Read"
  defp parse_status_and_date_read(%{status: :in_progress}), do: "In Progress"

  defp parse_status_and_date_read(%{status: :complete, date_read: date_read}),
    do: "Complete (#{transform_date_read(date_read)})"

  @spec transform_date_read(Date.t()) :: String.t()
  defp transform_date_read(date_read) do
    {year, month, day} = Date.to_erl(date_read)
    "#{month_abbrev(month)} #{day}, #{year}"
  end

  @spec month_abbrev(Integer.t()) :: String.t()
  defp month_abbrev(1), do: "Jan"
  defp month_abbrev(2), do: "Feb"
  defp month_abbrev(3), do: "Mar"
  defp month_abbrev(4), do: "Apr"
  defp month_abbrev(5), do: "May"
  defp month_abbrev(6), do: "Jun"
  defp month_abbrev(7), do: "Jul"
  defp month_abbrev(8), do: "Aug"
  defp month_abbrev(9), do: "Sep"
  defp month_abbrev(10), do: "Oct"
  defp month_abbrev(11), do: "Nov"
  defp month_abbrev(12), do: "Dec"
end
