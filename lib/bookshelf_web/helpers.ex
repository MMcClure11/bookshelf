defmodule BookshelfWeb.Helpers do
  @moduledoc """
  Helpers for templates and other web concerns.
  """

  @doc """
  Returns the appropriate background color given the current route in the
  `Plug.Conn`.
  """
  @spec background_color(Plug.Conn.t()) :: String.t()
  def background_color(conn) do
    conn
    |> Phoenix.Controller.current_path()
    |> get_background_color()
  end

  @spec get_background_color(String.t()) :: String.t()
  defp get_background_color("/custom-styles" <> _), do: "bg-dragonhide-600"
  defp get_background_color("/live-filter" <> _), do: "bg-dragonhide-600"
  defp get_background_color(_), do: "bg-white"
end
