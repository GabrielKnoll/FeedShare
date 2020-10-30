declare namespace AppleApi {
  type AmpPodcast = {
    id: string; // '409553739'
    type: 'podcasts';
    href: string; // '/v1/catalog/us/podcasts/409553739'
    attributes: {
      artwork: {
        width: number; // 1400;
        height: number;
        url: string; // 'https://is4-ssl.mzstatic.com/image/thumb/Podcasts113/v4/84/6e/74/846e740e-cb85-744e-8b5e-d8dc9a4b2c60/mza_7550981096815785933.png/{w}x{h}bb.{f}';
        bgColor: string; // 'b1dced';
        textColor1: string; // '08253c';
        textColor2: string; // '153044';
        textColor3: string; // '2a4a5f';
        textColor4: string; // '345266';
      };
      artistName: string; // 'Daniel Buechele';
      url: string; // 'https://podcasts.apple.com/us/podcast/luftpost-podcast/id409553739';
      subscribable: boolean;
      genreNames: string[]; // ['Places & Travel', 'Podcasts', 'Society & Culture', 'Sports', 'Wilderness'];
      createdDate: string; // '2010-12-11';
      trackCount: number;
      completed: boolean;
      seasonNumbers: [];
      name: string; // 'Luftpost Podcast';
      subscriptionUrl: string; // 'https://itunes.apple.com/WebObjects/DZR.woa/wa/subscribePodcast?cc=us&id=409553739';
      releaseDateTime: string; // '2020-08-28T20:38:00Z';
      languageTag: string; // 'de-DE';
      description: {
        standard: string; // 'Luftpost bringt in unregelmäßigen Abständen Interviews mit Leuten, die spannende Orte dieser Welt besucht haben. Gemeinsam sprechen wir über Kultur, Leben, Sehenswürdigkeiten und mehr Dinge, die es auf einer Reise dort zu erkunden gilt.';
      };
      websiteUrl: string; // 'https://luftpost-podcast.de';
      contentRating: string; // 'clean';
    };
    relationships: {
      artists: {
        href: string; // '/v1/catalog/us/podcasts/409553739/artists';
        data: [];
      };
    };
  };

  type AmpEpisode = {
    id: string; // '1000489471624';
    type: 'podcast-episodes';
    href: string; // '/v1/catalog/us/podcast-episodes/1000489471624';
    attributes: {
      artwork: {
        width: number;
        height: number;
        url: string; // 'https://is4-ssl.mzstatic.com/image/thumb/Podcasts113/v4/84/6e/74/846e740e-cb85-744e-8b5e-d8dc9a4b2c60/mza_7550981096815785933.png/{w}x{h}bb.{f}';
        bgColor: string; // 'b1dced';
        textColor1: string; // '08253c';
        textColor2: string; // '153044';
        textColor3: string; // '2a4a5f';
        textColor4: string; // '345266';
      };
      topics: [];
      artistName: string; // 'Daniel Buechele';
      url: string; // 'https://podcasts.apple.com/us/podcast/senegal/id409553739?i=1000489471624';
      subscribable: true;
      mediaKind: string; // 'audio';
      genreNames: string[]; // ['Places & Travel'];
      name: string; // 'Senegal';
      assetUrl: string; // 'https://luftpost-podcast.de/media/luftpost107-senegal.mp3';
      releaseDateTime: string; // '2020-08-28T20:38:26Z';
      durationInMilliseconds: number;
      guid: string; // 'https://luftpost-podcast.de/?p=1175';
      description: {
        standard: string; // 'Über Afrika ist auf meiner Landkarte immer noch etwas unterrepräsentiert, deshalb freut es mich um so mehr, dass ich mit Jessi über ihre Reise in den Senegal sprechen durfte. Sie war dort für drei Wochen mit ihrem Mann um dort in der Hauptstadt Dakar zum ersten Mal ihre Schwiegerfamilie zu treffen. Sie erzählt von der Gastfreundschaft und viel zu viel Essen, Ausflüge in die Wüste, Begegnungen mit Einheimischen und auch wie sie bei einer traditionellen Schlachtung eines Schafs mithelfen durfte/musste.';
        short: string; // 'Über Afrika ist auf meiner Landkarte immer noch etwas unterrepräsentiert, deshalb freut es mich um so mehr, dass ich mit Jessi über ihre Reise in den Senegal sprechen durfte. Sie war dort für drei Wochen mit ihrem Mann um dort in [...]';
      };
      websiteUrl: string; // 'https://luftpost-podcast.de/senegal/';
      contentRating: string; // 'clean';
    };
  };
}
