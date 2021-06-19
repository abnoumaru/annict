# frozen_string_literal: true

class AnimesController < ApplicationV6Controller
  def show
    set_page_category PageCategory::ANIME

    @anime = Anime.only_kept.find(params[:anime_id])
    @trailers = @anime.trailers.only_kept.order(:sort_number).first(5)
    @episodes = @anime.episodes.only_kept.order(:sort_number).first(29)
    # @casts = @anime.casts.only_kept.order(:sort_number)
    # @staffs = @anime.staffs.only_kept.order(:sort_number)
    # @vod_channels = Channel.only_kept.joins(:programs).merge(@anime.programs.only_kept.in_vod).order(:sort_number)
    @programs = @anime.programs.eager_load(:channel).only_kept.in_vod.merge(Channel.order(:sort_number))
  end
end
