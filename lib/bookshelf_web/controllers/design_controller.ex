defmodule BookshelfWeb.DesignController do
  use BookshelfWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
