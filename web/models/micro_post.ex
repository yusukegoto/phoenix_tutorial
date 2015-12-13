defmodule SampleApp.MicroPost do
  use SampleApp.Web, :model

  schema "micro_posts" do
    field :content
    belongs_to :user, SampleApp.User

    timestamps
  end

  @required_fields ~w(user_id)
  @optional_fields ~w(content)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
