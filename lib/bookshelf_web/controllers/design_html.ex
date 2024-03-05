defmodule BookshelfWeb.DesignHTML do
  use BookshelfWeb, :html

  def index(assigns) do
    ~H"""
    <h2 class="my-4 text-xl font-bold">Colors</h2>
    <div class="flex gap-6">
      <div>
        <div class="bg-dragonhide-100 h-8 w-16" />
        <div class="bg-dragonhide-200 h-8 w-16" />
        <div class="bg-dragonhide-300 h-8 w-16" />
        <div class="bg-dragonhide-400 h-8 w-16" />
        <div class="bg-dragonhide-500 h-8 w-16" />
        <div class="bg-dragonhide-600 h-8 w-16" />
        <div class="bg-dragonhide-700 h-8 w-16" />
        <div class="bg-dragonhide-800 h-8 w-16" />
      </div>
      <div>
        <div class="bg-ooze-100 h-8 w-16" />
        <div class="bg-ooze-200 h-8 w-16" />
        <div class="bg-ooze-300 h-8 w-16" />
        <div class="bg-ooze-400 h-8 w-16" />
        <div class="bg-ooze-500 h-8 w-16" />
        <div class="bg-ooze-600 h-8 w-16" />
        <div class="bg-ooze-700 h-8 w-16" />
        <div class="bg-ooze-800 h-8 w-16" />
      </div>
      <div class="flex flex-col gap-4">
        <div class="bg-rust h-8 w-16" />
        <div class="bg-gold h-8 w-16" />
        <div class="bg-copper h-8 w-16" />
        <div class="bg-silver h-8 w-16" />
      </div>
    </div>

    <h2 class="my-4 text-xl font-bold">Font Families</h2>
    <table class="border">
      <thead>
        <tr>
          <th class="border p-4">Font Family</th>
          <th class="border p-4">Example</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="border p-4 font-sans">Sans (default)</td>
          <td class="border p-4 font-sans">The quick brown fox jumps over the lazy dog.</td>
        </tr>
        <tr>
          <td class="border p-4 font-serif">Serif</td>
          <td class="border p-4 font-serif">The quick brown fox jumps over the lazy dog.</td>
        </tr>
        <tr>
          <td class="border p-4 font-['kalnia']">Kalnia</td>
          <td class="border p-4 font-['kalnia']">The quick brown fox jumps over the lazy dog.</td>
        </tr>
      </tbody>
    </table>
    """
  end
end
