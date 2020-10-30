declare namespace SpotifyAPI {
  interface ExternalUrls {
    spotify: string;
  }

  interface Image {
    height: number;
    url: string;
    width: number;
  }

  interface Episode {
    audio_preview_url: string;
    description: string;
    duration_ms: number;
    explicit: boolean;
    external_urls: ExternalUrls;
    href: string;
    id: string;
    images: Image[];
    is_externally_hosted: boolean;
    is_playable: boolean;
    language: string;
    languages: string[];
    name: string;
    release_date: string;
    release_date_precision: string;
    type: string;
    uri: string;
  }

  interface Show {
    available_markets: string[];
    copyrights: any[];
    description: string;
    explicit: boolean;
    external_urls: ExternalUrls;
    href: string;
    id: string;
    images: Image[];
    is_externally_hosted: boolean;
    languages: string[];
    media_type: string;
    name: string;
    publisher: string;
    total_episodes: number;
    type: string;
    uri: string;
  }

  type ShowsResponse = {
    episodes: {
      href: string;
      items: Episode[];
      limit: number;
      next: string;
      offset: number;
      previous?: any;
      total: number;
    };
  } & Show;

  type EpisodesReponse = {
    show: Show;
  } & Episode;
}
