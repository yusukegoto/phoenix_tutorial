defmodule SampleApp.UserView do
  use SampleApp.Web, :view

  def gravator_for(email) do
    id = gravator_id(email)
    raw ~s(<img src="https://secure.gravatar.com/avatar/#{id}" />)
  end

  def gravator_id(email) do
    email
    |> :erlang.md5
    |> Base.encode16(case: :lower)
  end
end
