defmodule BookshelfWeb.UpgradeTableLive do
  @moduledoc false

  use BookshelfWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_, _, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1 class="text-dragonhide-100 pb-6 font-['Kalnia'] text-[2rem] font-semibold leading-none">
      The Bookshelf
    </h1>

    <p class="text-dragonhide-100">Upgrade Table</p>
    """
  end
end
