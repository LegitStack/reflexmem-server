defmodule API.Router do
  require Logger
  import Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch

  post "/v1/customer/authentication" do
    test(_process_body(conn))
    case _process_body(conn) do
      {:ok, body} ->
        body.email
        body.subscription
        send_resp(conn, 200, Poison.encode! # TODO: Pass back the authentication token.)
      {:empty, msg} ->
        send_resp(conn, 404, Poison.encode! msg)
      {:error, _} ->
        send_resp(conn, 500, Poison.encode! %{:error, "Something went wrong, and it's all your fault."})
    end
  end

  def test({:ok, body}), do: # Do something
  def test({:empty, msg}), do: send_resp(conn, 404, Poison.encode! msg)
  def test({:error, _}), do: # Do something

  get "/v1/customer/authentication" do
  end

  put "/v1/customer/authentication" do
  end

  delete "/v1/customer/authentication" do
  end

  post "/v1/customer/subscription/" do
  end

  defp _process_body(conn) do
    case read_body(conn) do
      {:ok, body, _} ->
        cond do
          body == "" ->
            {:empty, "The body is empty."}
          true ->
            {:ok, Poison.decode!(body) |> _atomize}
        end
      _ ->
        {:error, %{}}
    end
  end

  defp _atomize(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end
end
