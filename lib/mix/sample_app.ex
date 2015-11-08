defmodule Mix.SampleApp do
  defmacro __using__(_) do
    quote do
      use Mix.Task
      alias SampleApp.User
      alias SampleApp.Repo
      import Ecto.Query
      import Mix.Ecto
      require Mix.SampleApp
      import  Mix.SampleApp
    end
  end

  defmacro open_repo(args, do: callback) do
    quote do
      repo = parse_repo unquote(args)

      {:ok, pid} = ensure_started(repo)

      unquote callback

      pid && ensure_stopped(pid)
    end
  end
end
