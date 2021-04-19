defmodule Membrane.WebRTC.Endpoint do
  @moduledoc """
  Module representing a WebRTC connection.
  """
  alias Membrane.WebRTC.Track

  @type id() :: any()
  @type type() :: :screensharing | :participant

  @type t :: %__MODULE__{
          id: id(),
          type: :participant | :screensharing,
          inbound_tracks: %{Track.id() => Track.t()}
        }

  defstruct id: nil, type: :participant, inbound_tracks: %{}

  @spec new(id :: id(), type :: type(), inbound_tracks :: [Track.t()]) :: Endpoint.t()
  def new(id, type, inbound_tracks) do
    inbound_tracks = Map.new(inbound_tracks, &{&1.id, &1})
    %__MODULE__{id: id, type: type, inbound_tracks: inbound_tracks}
  end

  @spec get_audio_tracks(endpoint :: Endpoint.t()) :: [Track.t()]
  def get_audio_tracks(endpoint),
    do: Map.values(endpoint.inbound_tracks) |> Enum.filter(&(&1.type == :audio))

  @spec get_video_tracks(endpoint :: Endpoint.t()) :: [Track.t()]
  def get_video_tracks(endpoint),
    do: Map.values(endpoint.inbound_tracks) |> Enum.filter(&(&1.type == :video))

  @spec get_track_by_id(endpoint :: Endpoint.t(), id :: Track.id()) :: Track.t() | nil
  def get_track_by_id(endpoint, id), do: endpoint.inbound_tracks[id]

  @spec get_tracks(endpoint :: Endpoint.t()) :: [Track.t()]
  def get_tracks(endpoint), do: Map.values(endpoint.inbound_tracks)

  @spec update_track_encoding(endpoint :: Endpoint.t(), track_id :: Track.id(), encoding :: atom) ::
          Endpoint.t()
  def update_track_encoding(endpoint, track_id, value),
    do: update_in(endpoint.inbound_tracks[track_id], &%Track{&1 | encoding: value})
end
