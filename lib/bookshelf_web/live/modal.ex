defmodule BookshelfWeb.ModalLive do
  @moduledoc false

  use BookshelfWeb, :live_view

  alias Bookshelf.Books
  alias Bookshelf.Books.Book

  @impl Phoenix.LiveView
  def mount(_, _, socket) do
    socket =
      socket
      |> assign(:details, nil)
      |> assign(:books, Books.create_book_structs())

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("change", %{"search" => %{"query" => query}}, socket) do
    {:noreply, assign(socket, :books, Books.filter_books(query))}
  end

  @impl Phoenix.LiveView
  def handle_event("show_details", %{"title" => title}, socket) do
    book = Books.get_book_by_title(title)
    {:noreply, assign(socket, :details, book)}
  end

  @impl Phoenix.LiveView
  def handle_event("hide_details", _value, socket) do
    schedule_destroy_modal()
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("esc_details", %{"key" => "Escape"}, socket) do
    schedule_destroy_modal()
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("esc_details", _value, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:destroy_modal, socket) do
    {:noreply, assign(socket, :details, nil)}
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
          class="bg-dragonhide-200 placeholder:text-dragonhide-400 text-dragonhide-600 h-12 w-80 rounded-sm indent-7 text-base leading-none tracking-normal"
          placeholder="Type to filter…"
        />
        <div class="text-dragonhide-500 pointer-events-none absolute inset-y-0 flex items-center pl-3">
          <.icon name="hero-magnifying-glass" class="h-5 w-5" />
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
          <.column_header text="Status" />
        </tr>
      </thead>
      <tbody>
        <%= for book <- @books do %>
          <tr class="text-dragonhide-100 bg-dragonhide-400 odd:bg-dragonhide-500 font-serif text-sm leading-normal">
            <.cell_data><%= book.title %></.cell_data>
            <.cell_data><%= book.author %></.cell_data>
            <.cell_data><%= book.genre %></.cell_data>
            <.cell_data class="focus-within:border-ooze-300 font-sans text-xs leading-snug focus-within:border-2">
              <button
                phx-click={JS.push("show_details", value: %{title: book.title}) |> open_modal()}
                tabindex="0"
                class="duration-250 hocus:scale-105 w-full transform transition focus:outline-none"
                aria-label={"#{book.title} details"}
              >
                <.review value={book.review} />
              </button>
            </.cell_data>
            <.cell_data class="flex">
              <.status_and_date_read status={book.status} date_read={book.date_read} />
            </.cell_data>
          </tr>
        <% end %>
      </tbody>
    </table>

    <div :if={@details} class="relative z-10">
      <div
        id="modal-overlay"
        class="motion-safe:animate-fade-in fixed inset-0 bg-black/[.66]"
        aria-hidden="true"
      />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@details.title}-title"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <.focus_wrap
            id="modal-container"
            phx-click-away={JS.push("hide_details") |> close_modal()}
            phx-window-keyup={JS.push("esc_details") |> close_modal()}
            phx-key="escape"
            class="bg-rust-900 motion-safe:animate-fade-in relative w-7/12 rounded-sm p-20 shadow-2xl"
          >
            <button
              phx-click={JS.push("hide_details") |> close_modal()}
              type="button"
              class="focus:border-dragonhide-300 absolute left-7 top-7 text-white focus:border focus:outline-none"
              aria-label={gettext("close")}
            >
              <.icon name="hero-x-mark" class="h-6 w-6" />
            </button>
            <div id={"#{@details.title}-content"}>
              <div class="flex gap-12">
                <img
                  class="h-80"
                  src={
                    if is_nil(@details.cover_art),
                      do:
                        "https://static.vecteezy.com/system/resources/previews/027/205/141/original/hand-draw-open-book-lying-on-high-stack-of-books-isolated-free-vector.jpg",
                      else: @details.cover_art
                  }
                  alt={@details.title}
                />
                <div class="flex w-full flex-col gap-6">
                  <div class="flex justify-between">
                    <div>
                      <h1 class="text-dragonhide-100 font-serif text-4xl leading-tight">
                        <%= @details.title %>
                      </h1>
                      <h2 class="text-dragonhide-300 text-base uppercase leading-tight tracking-wider">
                        By <%= @details.author %>
                      </h2>
                    </div>
                    <.status_and_date_read status={@details.status} date_read={@details.date_read} />
                  </div>
                  <.full_review value={@details.review} />
                </div>
              </div>
            </div>
          </.focus_wrap>
        </div>
      </div>
    </div>
    """
  end

  @spec close_modal(map()) :: map()
  defp close_modal(js) do
    js
    |> JS.remove_class("motion-safe:animate-fade-in", to: "#modal-overlay")
    |> JS.remove_class("motion-safe:animate-fade-in", to: "#modal-container")
    |> JS.remove_class("overflow-y-hidden", to: "#body")
    |> JS.add_class("motion-safe:animate-fade-out", to: "#modal-overlay")
    |> JS.add_class("motion-safe:animate-fade-out", to: "#modal-container")
  end

  @spec open_modal(map()) :: map()
  defp open_modal(js) do
    JS.add_class(js, "overflow-y-hidden", to: "#body")
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
    <p class="text-left">— —</p>
    """
  end

  defp review(assigns) do
    ~H"""
    <p class="line-clamp-2 text-left"><%= List.first(@value) %></p>
    """
  end

  attr :value, :list, required: true

  defp full_review(%{value: nil} = assigns) do
    ~H"""
    <p class="text-dragonhide-100">— —</p>
    """
  end

  defp full_review(assigns) do
    ~H"""
    <%= for item <- @value do %>
      <p class="text-dragonhide-100 mb-2 font-serif text-base leading-snug last:mb-0"><%= item %></p>
    <% end %>
    """
  end

  attr :date_read, :any, required: true
  attr :status, :atom, required: true

  defp status_and_date_read(%{status: :complete} = assigns) do
    ~H"""
    <div class="relative">
      <div class="absolute h-3 w-3 -translate-x-1 -translate-y-1 rounded-full bg-white" />
      <div class="absolute -translate-x-2 -translate-y-2">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#50704D" class="h-6 w-6">
          <path
            fill-rule="evenodd"
            d="M8.603 3.799A4.49 4.49 0 0 1 12 2.25c1.357 0 2.573.6 3.397 1.549a4.49 4.49 0 0 1 3.498 1.307 4.491 4.491 0 0 1 1.307 3.497A4.49 4.49 0 0 1 21.75 12a4.49 4.49 0 0 1-1.549 3.397 4.491 4.491 0 0 1-1.307 3.497 4.491 4.491 0 0 1-3.497 1.307A4.49 4.49 0 0 1 12 21.75a4.49 4.49 0 0 1-3.397-1.549 4.49 4.49 0 0 1-3.498-1.306 4.491 4.491 0 0 1-1.307-3.498A4.49 4.49 0 0 1 2.25 12c0-1.357.6-2.573 1.549-3.397a4.49 4.49 0 0 1 1.307-3.497 4.49 4.49 0 0 1 3.497-1.307Zm7.007 6.387a.75.75 0 1 0-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 0 0-1.06 1.06l2.25 2.25a.75.75 0 0 0 1.14-.094l3.75-5.25Z"
            clip-rule="evenodd"
          />
        </svg>
      </div>
      <div class={["bg-gold min-w-max rounded-full px-4 py-2"]}>
        <p class={pill_text_class()}>
          <%= transform_date_read(@date_read) %>
        </p>
      </div>
    </div>
    """
  end

  defp status_and_date_read(assigns) do
    ~H"""
    <div class="relative">
      <div class={["bg-#{parse_status(@status, :color)} min-w-max rounded-full px-4 py-2"]}>
        <p class={pill_text_class()}>
          <%= parse_status(@status, :text) %>
        </p>
      </div>
    </div>
    """
  end

  @spec pill_text_class :: String.t()
  defp pill_text_class,
    do:
      "text-dragonhide-100 font-sans text-[0.5625rem] font-bold uppercase leading-none tracking-wider"

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

  @spec parse_status(Book.status(), :text | :color) :: String.t()
  defp parse_status(:want_to_read, :text), do: "Want to Read"
  defp parse_status(:in_progress, :text), do: "In Progress"
  defp parse_status(:want_to_read, :color), do: "silver"
  defp parse_status(:in_progress, :color), do: "copper"

  @spec schedule_destroy_modal() :: reference()
  defp schedule_destroy_modal do
    Process.send_after(self(), :destroy_modal, 250)
  end
end
