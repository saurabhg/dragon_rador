import cgi

from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext import db

class User(db.Model):
  name = db.StringProperty(required=True)
  location = db.StringProperty()
  last_updated = db.DateTimeProperty(auto_now_add=True)

class MainPage(webapp.RequestHandler):
  def get(self):
    self.response.out.write('<html><body>')

    users = db.GqlQuery("SELECT * FROM User ORDER BY last_updated DESC LIMIT 10")

    for user in users:
      if user.name:
        #self.response.out.write('<b>%s</b> wrote:' % user.name())
        self.response.out.write('<b>hoge</b> wrote:')
      else:
        self.response.out.write('An anonymous person wrote:')
      self.response.out.write('<blockquote>%s</blockquote>' %
                              cgi.escape(user.name))

    # Write the submission form and the footer of the page
    self.response.out.write("""
          <form action="/sign" method="post">
            <div><textarea name="content" rows="3" cols="60"></textarea></div>
            <div><input type="submit" value="Sign Guestbook"></div>
          </form>
        </body>
      </html>""")

class Guestbook(webapp.RequestHandler):
  def post(self):
    ctt = self.request.get('content')
    user = User(name=ctt, location=ctt)
    user.put()
    self.redirect('/')

application = webapp.WSGIApplication(
                                     [('/', MainPage),
                                      ('/sign', Guestbook)],
                                     debug=True)

def main():
  run_wsgi_app(application)

if __name__ == "__main__":
  main()
