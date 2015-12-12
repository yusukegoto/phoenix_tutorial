defmodule SampleApp.Paging.Pager do
  defstruct [:current_page, :total_page, :total_count, :entries]

  alias SampleApp.Repo
  import Ecto.Query

  def new(query, params \\ %{}) do
    page     = Map.get params, :page, 1
    per_page = Map.get params, :per_page, 10

    offset = (page - 1) * per_page
    total_count = query
                  |> select([u], count(u.id))
                  |> Repo.one
    total_page = (total_count / per_page) |> Float.ceil |> round
    q = query
        |> limit([u],  ^per_page)
        |> offset([u], ^offset)

    %SampleApp.Paging.Pager{current_page: page,
      total_page:   total_page,
      total_count:  total_count,
      entries:      q}
  end
end
