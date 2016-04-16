import re

from livestreamer.compat import urljoin
from livestreamer.plugin import Plugin
from livestreamer.plugin.api import http, validate
from livestreamer.stream import RTMPStream, HLSStream

_PLAYLIST_URL = "https://lancer.streamup.com/api/channels/{}s-channel/playlists"

_url_re = re.compile("http(s)?://(\w+\.)?streamup.com/(?P<channel>[^/?]+)")

class StreamupCom(Plugin):
    @classmethod
    def can_handle_url(cls, url):
        return _url_re.match(url)

    def _get_streams(self):
        channel = _url_re.match(self.url).group('channel')
        res = http.get(_PLAYLIST_URL.format(channel))
        if not res: return
        match = http.json(res)
        hls_url = match[u'hls']
        return HLSStream.parse_variant_playlist(self.session, hls_url)

__plugin__ = StreamupCom
