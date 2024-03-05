defmodule BookshelfWeb.LiveFilterLive do
  @moduledoc false

  use BookshelfWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-dragonhide-100 pb-6 font-['Kalnia'] text-[2rem] font-semibold leading-none">
      The Bookshelf
    </h1>
    <p class="text-dragonhide-100">Live Filter</p>
    """
  end
end
