defmodule SampleApp.Repo.Migrations.AddMicroposts do
  use Ecto.Migration

  def change do
    create table(:micro_posts) do
      add :content, :text
      add :user_id, references(:users)

      timestamps
    end

    create index(:micro_posts, [:user_id, :inserted_at])
  end
end
