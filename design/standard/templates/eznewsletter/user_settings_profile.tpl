{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{* eZNewsletter - edit newslettertype *}
{*<form method="post" action={concat( '/newsletter/user_settings/', $hash)|ezurl}>*}

<div class="context-block">
{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">
<h2 class="context-title">{'Your settings'|i18n( 'design/eznewsletter/user_settings_profile' )}</h2>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-ml"><div class="box-mr"><div class="box-content">

<div class="context-attributes">

{if is_set($warning)}
    <div class="message-warning">
        <h2>{$warning|wash}</h2>
    </div>
{/if}

{* Name. *}
<div class="block">
<label>{'Firstname'|i18n( 'design/eznewsletter/user_settings_profile' )}:</label>
<input class="halfbox" id="firstname" type="text" name="FirstName" value="{$userData.firstname|wash}" />
</div>

<div class="block">
<label>{'Name'|i18n( 'design/eznewsletter/user_settings_profile' )}:</label>
<input class="halfbox" id="username" type="text" name="Name" value="{$userData.name|wash}" />
</div>

<div class="block">
<label>{'Mobile'|i18n( 'design/eznewsletter/user_settings_profile' )}:</label>
<input class="halfbox" id="mobile" type="text" name="Mobile" value="{$userData.mobile|wash}" />
</div>

<div class="block">
<label>{'Email'|i18n( 'design/eznewsletter/user_settings_profile' )}:</label>
<input class="halfbox" id="email" type="text" name="Email" value="{$userData.email|wash}" />
</div>

{* Password. *}

{if $userData.password}
    <div class="block">
        <label>{"Password"|i18n( 'design/eznewsletter/user_settings_profile' )}:</label>
        <input name="Password1" size="25" type="password" value="password" />
        <input name="Password2" size="25" type="password" value="password" />
    </div>
{/if}

{* TODO : PASSWORD *}

{* DESIGN: Content END *}</div></div></div>

{* Buttons. *}
<div class="controlbar">
{* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br">
<div class="block">
    <input class="button" type="submit" name="UpdateSubscriptions" value="{'Update'|i18n( 'design/eznewsletter/user_settings_profile' )}" title="{'Update settings.'|i18n( 'design/eznewsletter/user_settings_profile' )}" />
</div>
{* DESIGN: Control bar END *}</div></div></div></div></div></div>
</div>
</div>
{*</form>*}
