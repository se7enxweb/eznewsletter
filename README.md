# eZ Newsletter for Exponential

eZ Newsletter (`eznewsletter`) is a newsletter extension for Exponential 6.x. Editors write a newsletter
issue as an ordinary content object, choose who receives it, preview it, and a cronjob sends it to the
subscribers of one or more subscription lists. The extension keeps the subscription lists, handles
sign-ups and sign-outs, honors a "do not mail" (Robinson) list, reads bounces from a mailbox and counts
who opened which article.

It is meant for site owners and integrators who want newsletters managed inside the CMS rather than in an
external mailing service.

## Features

- **Newsletter types**: a type bundles the defaults of a newsletter: the sender address, the subscription
  lists it goes to, the content classes an issue may be made of, the article pool (where issues are
  created), the inbox, the allowed designs and siteaccesses, a pre and post text, a send delay and whether
  mails are personalized.
- **Issues are content objects**: an issue is created from its type and edited in the normal content
  editor, which gains newsletter fields (name, send date, category, preview address, design, recurrence).
- **Preview**: in the browser (`newsletter/preview`, `newsletter/previewfull`) and as a test mail to a
  preview address.
- **Sendout by cronjob** in plain text and HTML (with embedded images), through sendmail, SMTP, a
  round-robin cluster of SMTP servers, or to files for later delivery. An SMS transport class exists for
  custom gateways.
- **Personalization**: `[firstname]`, `[name]`, `[email]`, `[mobile]`, `[userhash]` and
  `[generic_userhash]` in a sendout template are replaced per recipient.
- **Recurring newsletters**: daily, weekly or monthly, optionally with a condition, republished by a
  cronjob.
- **Subscription lists**: create lists, add and edit subscribers, import them from CSV, search them, let
  visitors subscribe with double opt-in and manage their own settings, and unsubscribe with a link.
- **Subscribe and unsubscribe by e-mail**: a cronjob reads a mailbox and acts on mails sent to a subscribe
  or unsubscribe address.
- **Robinson list**: addresses and mobile numbers that never receive a newsletter, with import and edit
  views.
- **Bounce management**: a cronjob reads bounces from POP3 or IMAP mailboxes; bounces are listed, searched
  and removed in the admin, and an address that bounced too often is left out of the next sendout.
- **Read tracking**: links through `newsletter/read` count which recipient read which object of a sent
  newsletter.
- **Extras**: a `newsletterlist` datatype (lets a user choose subscription lists from a content object
  form), two workflow events (`Newsletter read` and `Newsletter import event`), template operators and
  fetch functions, translations (English, French, German, Norwegian).

## Requirements

- Exponential 6.x (the legacy kernel) with the `ezjscore` extension, which ships with the kernel.
- PHP 8.0 or newer.
- MySQL or MariaDB. The schema is also provided in the database-neutral `.dba` format.
- Optional: the PHP `imap` extension for the bounce and e-mail subscription cronjobs (`check_bounce.php`,
  `email_subscribe.php`). Since PHP 8.4 it is no longer bundled with PHP and comes from PECL.

## Installation

### With Composer

From the root of your Exponential installation:

```bash
composer require se7enxweb/eznewsletter
```

The `se7enxweb/exponential-legacy-installer` plugin places the package in `extension/eznewsletter`.

### By hand

1. Download a release from https://github.com/se7enxweb/eznewsletter/releases (or clone the repository)
   and put its contents in `extension/eznewsletter` of your installation.

### Then, in both cases

1. Activate the extension in `settings/override/site.ini.append.php`:

   ```ini
   [ExtensionSettings]
   ActiveExtensions[]=eznewsletter
   ```

2. Create the database tables. For MySQL or MariaDB:

   ```bash
   mysql -u <user> -p <database> < extension/eznewsletter/sql/mysql/eznewsletter.sql
   ```

   For another database type, insert the `.dba` schema with the kernel script, for example:

   ```bash
   php bin/php/ezsqlinsertschema.php --type=postgresql --user=<user> --password=<password> \
       extension/eznewsletter/sql/eznewsletter.dba <database>
   ```

3. Regenerate the autoload arrays and clear the caches:

   ```bash
   php bin/php/ezpgenerateautoloads.php -e
   php bin/php/ezcache.php --clear-all
   ```

4. Optional: import the content classes from `extension/eznewsletter/packages` in the admin under
   Setup, Packages, Import. `eznewsletter_classes.ezpkg` holds the classes `newsletter_issue` and
   `newsletter_article`, `newsletterclasses-1.0-1.ezpkg` holds `newsletter` and `newsletter_group`, and
   `eznewsletter_democontent.ezpkg` holds demo content. You can also use any class of your own as an
   issue.

5. Give roles the policies they need (see [Permissions](#permissions)) and set up the cronjobs (see
   [Cronjobs](#cronjobs)).

## Usage

### The admin tab

After activation the admin shows a **Newsletter** tab (with an envelope icon in admin4). Its left menu
leads to:

| Menu entry        | View                           |
| ----------------- | ------------------------------ |
| Newsletter types  | `newsletter/list_type`         |
| Subscription lists| `newsletter/list_subscriptions`|
| Search subscriber | `newsletter/subscription_search`|
| Bounce list       | `newsletter/list_bounce/all`   |
| Search bounce     | `newsletter/bounce_search`     |
| Robinson list     | `newsletter/robinson_show`     |

`settings/menu.ini.append.php` also defines tabs from an older layout that are switched off by default:
List management (icon `list-task`), Search subscriber (`search`) and Bounce management (`inbox`). To show
them, add them to the tab list in your own `menu.ini.append.php`:

```ini
[TopAdminMenu]
Tabs[]=eznewsletterList
Tabs[]=eznewsletterSearch
Tabs[]=eznewsletterBounce
```

### Sending a first newsletter, step by step

1. **Create a subscription list**: Newsletter tab, Subscription lists, create a list. Give it a name and a
   URL name (used in sign-up links), choose whether anonymous visitors may subscribe, whether a password
   is required and whether registered users are confirmed and approved automatically.
2. **Add subscribers**: add them one by one on the list's page, or import a CSV file
   (`newsletter/subscription_import/<list id>`).
3. **Create a newsletter type**: Newsletter tab, Newsletter types, create a type. Set the sender address,
   pick the subscription lists, the content classes allowed for issues, the article pool (the location
   where issues are created) and the designs.
4. **Create an issue**: open the type (`newsletter/view_type/<type id>`) and create a newsletter. The
   content editor opens with the newsletter fields. Set the send date, write the content, and use
   **Preview** or **Send preview** to check it.
5. **Publish** the issue. When its send date has passed, the `send_newsletter` cronjob builds the list
   of recipients and sends the mails. Sent issues appear under the type's archive, issues being sent
   under "in progress".

### Sign-up and settings for visitors

| URL                                               | What it does                                     |
| ------------------------------------------------- | ------------------------------------------------ |
| `newsletter/register_subscription/<list id or URL name>` | Sign-up form for a list (double opt-in mail) |
| `newsletter/subscription_activate/<hash>`         | Confirms a subscription (link in the mail)       |
| `newsletter/user_settings/<hash>`                 | The subscriber's own settings                    |
| `newsletteraddons/subscription`                   | Add or remove the current user's subscriptions   |
| `newsletteraddons/register_subscription/<list id>`| Sign-up form without a policy check              |
| `newsletteraddons/unregister_subscription/<hash>` | Unsubscribe link for mails                       |
| `newsletter/robinson_user`                        | Lets a visitor add or remove an address or mobile number on the Robinson list |

### Sendout templates (designs)

A newsletter is rendered with `design:<design>/sendout/text.tpl` and `design:<design>/sendout/html.tpl`,
where `<design>` is the design chosen for the issue (default `eznewsletter`). The designs offered in the
editor are listed in `newsletterdesigns.ini`:

```ini
[Designs]
Design[]=eznewsletter
Design[]=mydesign

[mydesign]
Description=My company design
PreviewImage=mydesign.jpg
```

Put your templates in `templates/mydesign/sendout/` of a design your siteaccess uses. The templates get
`$contentobject`, `$newsletter` and `$hostname`. Placeholders are replaced per recipient, for example:

```
{set-block variable=$subject scope=root}{$contentobject.name|wash} - [name]{/set-block}
<p>Hello [firstname] [name],</p>
...
<a href="{eZDefaultHostname(1)}/newsletteraddons/unregister_subscription/[userhash]">Unsubscribe</a>
```

When the type is not personalized, `[name]` is replaced with an empty string.

### Template operators

| Operator                  | Returns                                                                    |
| ------------------------- | -------------------------------------------------------------------------- |
| `eZDefaultHostname()`     | `[HostSettings] defaulthost` of `eznewsletter.ini`                         |
| `eZDefaultHostname(1)`    | the same without a trailing `index.php`, for links to images and storage    |
| `current_siteaccess()`    | the name of the current siteaccess                                         |
| `newsletter_topmenu('content')` | the admin top menu entries built from `menu.ini` for a context       |

### Fetch functions

All fetch functions are in the `newsletter` module. Examples taken from the extension's templates:

```
{* number of newsletters of a type, and the unsent ones *}
{def $count  = fetch( 'newsletter', 'newsletter_count', hash( 'type_id', $newsletter_type.id ) )
     $drafts = fetch( 'newsletter', 'newsletter_list_by_type', hash( 'type_id', $newsletter_type.id,
                                                                    'is_sent', false() ) )}

{* the newsletter behind a content object version *}
{def $newsletter = fetch( 'newsletter', 'newsletter_by_object',
                          hash( 'contentobject_id', $objectID, 'contentobject_version', $objectVersion ) )}

{* bounce counts *}
{def $bounces = fetch( 'newsletter', 'grouped_bounce_count' )}
```

The full list: `version`, `newsletter_type_count`, `newsletter_type_list`, `subscription_list_count`,
`list_subscriptions`, `subscription_array_by_user_id`, `subscription_array_by_email`,
`subscription_by_id`, `active_subscriptions_by_user_id`, `active_subscriptions_by_email`, `user_data`,
`newsletter_count`, `newsletter`, `newsletter_by_object`, `newsletter_by_hash`,
`newsletter_list_by_type`, `newsletter_read_stat`, `bounce_count`, `grouped_bounce_count`,
`object_stat` and `onhold_count`. Their parameters are in `modules/newsletter/function_definition.php`.

### Read tracking

Links of the form `newsletter/read/<send item hash>/<object id>/<newsletter node id>` count a read for
the recipient and redirect to the newsletter. With `confidentRedirect=enabled` every object id is
counted, also objects that were not sent with the newsletter (for example links your template adds).
The counts are shown in the admin and available through `newsletter_read_stat` and `object_stat`.

## Configuration

Override these files in `settings/override/` or a siteaccess, never in the extension itself.

### eznewsletter.ini

```ini
[HostSettings]
# Host used for links and images in sent mails (eZDefaultHostname operator)
defaulthost=https://www.example.com

[NewsletterSendout]
# Transport for preview mails and for the sendout cronjob:
# eZNewsletterSendmailTransport, eZNewsletterSMTPTransport or eZNewsletterFileTransport
PreviewTransport=eZNewsletterSendmailTransport
Transport=eZNewsletterSendmailTransport

[NewsletterTypeSettings]
# Content classes offered for issues; empty means all classes
ClassLimitation[]
ClassLimitation[]=newsletter_issue

[NewsletterReadcount]
confidentRedirect=enabled

[NewsletterAutomapping]
# Copy attributes of the newsletter type into the issue object
autoMapping=disabled
#newsletter_issue[pretext]=pretext

[RecurrenceSettings]
# Extensions that provide conditions for recurring newsletters
conditionExtensions[]

[NotifySettings]
# Who is told when a subscriber confirms a subscription, and from which sender
Receivers[]
Receivers[]=newsletter@example.com
ReceiversName[]
ReceiversName[]=Newsletter team
Sender=noreply@example.com
SenderName=Newsletter

[SendConfirmation]
# Optional sender of the confirmation mails; falls back to site.ini [MailSettings] EmailSender
Sender=noreply@example.com
SenderName=Newsletter
```

The SMTP transport uses the kernel's `site.ini [MailSettings]` (`TransportServer`, `TransportPort`,
`TransportUser`, `TransportPassword`, `TransportConnectionType`).

### ezsendmailsettings.ini (sendmail transport)

```ini
[SendNewsletter]
ReplaceMessageIDHost=disabled
Host=example.com
# Envelope return path option of your MTA: -XV for sendmail, -v for exim
MTAEnvelopeReturnPathParameter="-XV"
```

### ezsmtpclustersettings.ini (cluster_send cronjob)

```ini
[SMTPClusterSettings]
PersistentConnection=enabled

[SMTPAccountSettings]
AccountList[]
AccountList[]=smtp1

[smtp1]
ServerName=smtp1.example.com
ServerPort=25
LoginName=
Password=

[RoundRobinSettings]
# Mails per server before switching, and retries
PackageSize=500
MaximumRetry=2
```

### bounce.ini (check_bounce cronjob)

```ini
[MailAccountSettings]
AccountList[]
AccountList[]=Bounces

[Bounces]
ServerName=mail.example.com
ServerPort=143
LoginName=bounces@example.com
Password=secret
# imap or pop3
Protocol=imap
Flags[]
Flags[]=notls

[BounceSettings]
# An address with this many bounces is left out of the next sendout
BounceCount=2
```

### email_subscribe.ini (email_subscribe cronjob)

Uses the same account format as `bounce.ini`, plus the two addresses it watches. The subject of the
mail names the subscription list by its URL name.

```ini
[EmailSettings]
SubscribeEmail=subscribe@example.com
UnsubscribeEmail=unsubscribe@example.com
```

### ezsmssettings.ini

`[provider] Username`, `Password` and `Originator` for an SMS gateway class of your own.

## Permissions

The `newsletter` module has these policy functions (Users, Roles, add a policy):

| Function                 | Grants                                                                     |
| ------------------------ | -------------------------------------------------------------------------- |
| `view_admin`             | the admin lists: types, issues, subscription lists, searches, Robinson list |
| `create_newsletter_type` | creating and editing newsletter types                                      |
| `create_newsletter`      | copying a newsletter (`newsletter/copy`)                                    |
| `admin_subscription`     | editing lists and subscribers, CSV and Robinson import                      |
| `bounce`                 | the bounce list                                                            |
| `preview`                | browser previews                                                           |
| `subscribe`              | sign-up, activation and subscriber settings                                |
| `read`                   | read tracking links (`newsletter/read`)                                    |
| `robinson`               | `newsletter/robinson_user`                                                 |

Give the Anonymous role `newsletter/subscribe` and `newsletter/read` so visitors can sign up and the read
links work. The `newsletteraddons` views need no policy (they are in `site.ini [RoleSettings]
PolicyOmitList[]`).

## Cronjobs

The extension registers cronjob parts in `cronjob.ini`. Run them from the installation root, for example
every 5 minutes for the sendout:

```bash
php runcronjobs.php send_newsletter       # build_list.php, send_newsletter.php, recurring_newsletter.php
php runcronjobs.php cluster_send          # the same, sending through the SMTP cluster
php runcronjobs.php check_bounce          # read bounces (needs ext-imap)
php runcronjobs.php email_subscribe       # subscribe/unsubscribe by mail (needs ext-imap)
php runcronjobs.php recurring_newsletter  # only republish recurring newsletters
php runcronjobs.php send_sms              # SMS sendout
```

Add `-s <siteaccess>` when the settings live in a siteaccess. A crontab line:

```
*/5 * * * * cd /path/to/exponential && php runcronjobs.php -q send_newsletter
```

The sendout scripts write a PID file, `run/eznewsletter.pid` in the var directory of the site, and refuse to start while it
exists. If a run crashed, delete that file before the next run.

## Upgrading

- From 1.7.0 to 1.7.1: no database change. Replace the files, regenerate autoloads and clear the caches.
- From older versions: run the scripts in `update/database/mysql/` in order (`dbupdate-10-to-15.sql`,
  `dbupdate-1_5-to-1_5_3.sql`, `dbupdate-1_5-to-1_6_0beta.sql`, `dbupdate-1_6_0beta-to-1_6_0.sql`). See
  also `doc/update/`.
- Do **not** run `dbupdate-1_7_to-1_8.sql`: it drops the `output_format` columns, which this version still
  reads.

## Known limits

- The Newsletter setup tab (`Topmenu_eznewsletter_setup`, icon `gear`) is switched off and points to
  `newsletter_setup/general`, a module this extension does not contain.
- The default `[CronjobSettings] Scripts[]` list and the `conditional_send` part both include
  `conditional_send.php`, which is not part of the extension. Run the parts listed above instead of a plain
  `php runcronjobs.php`, or empty `Scripts[]` in your override and list only the scripts you use.
- `send_newsletter.php` reads `[NewsletterContentClasses] newsletterContentClassIdent` from
  `eznewsletter.ini`, which is not set by default; set it in your override if the cronjob reports it
  missing.
- The `Newsletter import event` workflow event creates newsletters with the template name
  `mobotixnewsletter` hard-coded.
- `[BounceSettings] HardBounceCount` and `[NewsletterReadcount] redirectTarget` are in the default INI
  but not read by the code.
- The database scripts are for MySQL; other databases need the `.dba` schema.

## Troubleshooting

- **The tab or views are missing**: check that `eznewsletter` is in `ActiveExtensions[]`, regenerate
  autoloads and clear all caches.
- **"Access denied" on sign-up or read links**: give Anonymous `newsletter/subscribe` and
  `newsletter/read`.
- **Nothing is sent**: the issue must be published and its send date past; run
  `php runcronjobs.php send_newsletter` by hand and read its output. Check for a stale
  `var/<site>/run/eznewsletter.pid`.
- **Links or images in mails point to the wrong host**: set `[HostSettings] defaulthost` in
  `eznewsletter.ini`.
- **`Call to undefined function imap_open()`**: install the PHP `imap` extension for the CLI.

## Contributing

Issues and pull requests are welcome at https://github.com/se7enxweb/eznewsletter. Please describe the
Exponential and PHP version you use.

## License

GNU General Public License, version 2.0. See [LICENSE](LICENSE).

## Credits and history

eZ Newsletter was written by eZ Systems AS for eZ Publish, the legacy CMS that eZ Systems developed for
about 18 years before discontinuing it. It once bundled the separate add-ons eznewsletter_builder,
eznewsletter_designs, ezapprove2, ezlabel and ezmailimport (as its old ezinfo.php recorded), and in 2012 absorbed the
eznewsletteraddons extension. xrow GmbH maintained it from 2012 to 2015. Since 2024 7x
(https://se7enx.com) maintains it for Exponential. The change history is in [ChangeLog](ChangeLog) and
[Changelog.txt](Changelog.txt).
