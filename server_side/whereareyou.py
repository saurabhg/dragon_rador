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
        self.response.out.write('<b>%s</b> wrote:' % user.name)
      else:
        self.response.out.write('An anonymous person wrote:')

      self.response.out.write('<blockquote>%s</blockquote>' % cgi.escape(user.name))

    # Write the submission form and the footer of the page
    self.response.out.write("""
          <form action="/register" method="post">
            <div><textarea name="user_name" rows="1" cols="60"></textarea></div>
            <div><input type="submit" value="Sign Guestbook"></div>
          </form>
        </body>
      </html>""")

class UserInfo(webapp.RequestHandler):
   def get(self):
      name = self.request.get('name')
      users = db.GqlQuery("SELECT * FROM User WHERE name='%s' LIMIT 1" % name)
      if users.count() == 0:
         self.response.out.write('no user')
         return

      for user in users:
         self.response.out.write('UserInfo: ')
         self.response.out.write('name: %s ' % user.name)
         self.response.out.write('location: %s ' % user.location)
         self.response.out.write('last_updated: %s ' % user.last_updated)


class Register(webapp.RequestHandler):
   def post(self):
      user_name = self.request.get('user_name')
      # authorize it
      # if successully authorized, register it as User
      user = User(name=user_name)
      user.put()
      self.response.out.write('true')

      # else return error
      #self.response.out.write('false')

class Updater(webapp.RequestHandler):
   def get(self):
    self.response.out.write("""
          <form action="/update" method="post">
            <div><label>user: </label><input name="name" /></div>
            <div><input name="location" /></div>
            <div><input type="submit" value="Sign Guestbook"></div>
          </form>
        </body>
      </html>""")

   def post(self):
      name = self.request.get('name')
      users = db.GqlQuery("SELECT * FROM User WHERE name='%s' LIMIT 1" % name)
      if users.count() == 0:
         self.response.out.write('no user')
         return

      for user in users:
         user.location = self.request.get('location')
         user.put()
         self.response.out.write('updated')

application = webapp.WSGIApplication(
                                     [('/', MainPage),
                                      ('/user', UserInfo),
                                      ('/update', Updater),
                                      ('/register', Register)],
                                     debug=True)

def main():
  run_wsgi_app(application)

if __name__ == "__main__":
  main()
