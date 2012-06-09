{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{def $base_uri=concat( '/newsletter/register_subscription/', $subscriptionList.url_alias )}

<div class="box">
<div class="tl"><div class="tr"><div class="br"><div class="bl"><div class="box-content float-break">

<div class="content-view-full">
    <div class="class-folder">


        <div class="attribute-header">
            <h2>{'Register subscription'|i18n( 'design/eznewsletter/register_subscription' )}</h2>
        </div>

{if $warning}
    <div class="message-warning">
        <h3>{$warning|wash}</h3>
    </div>
{/if}

<form name="subscription_list" method="post" action={$base_uri|ezurl}>

    {* First name. *}
    <div class="block">
        <label>{"First name"|i18n( 'design/eznewsletter/register_subscription' )}:</label>
        <input class="halfbox" id="subscriptionFirstname" type="text" name="Firstname" value="{cond( is_set( $user), $user.contentobject.data_map.first_name.content, $firstname)|wash}" title="{'First name of the subscriber.'|i18n( 'design/eznewsletter/register_subscription' )}"
               {cond( is_set( $user ), 'disabled="disabled"', '')} />
    </div>

    {* Last name. *}
    <div class="block">
        <label>{"Last name"|i18n( 'design/eznewsletter/register_subscription' )}:</label>
        <input class="halfbox" id="subscriptionName" type="text" name="Name" value="{cond( is_set( $user ), $user.contentobject.data_map.last_name.content, $name)|wash}" title="{'Last name of the subscriber.'|i18n( 'design/eznewsletter/register_subscription' )}"
               {cond( is_set( $user ), 'disabled="disabled"', '')} />
    </div>

    {* Mobile. *}
    <div class="block">
        <label>{"Mobile number"|i18n( 'design/eznewsletter/register_subscription' )}:</label>
        <input class="halfbox" id="subscriptionMoile" type="text" name="Mobile" value="{cond( is_set( $user ), $user.$mobile, $mobile)|wash}" title="{'Mobile number of the subscriber.'|i18n( 'design/eznewsletter/register_subscription' )}"
               {cond( is_set( $user ), 'readonly="readonly"', '')} />
    </div>

    {* Email. *}
    <div class="block">
        <label>{"Email"|i18n( 'design/eznewsletter/register_subscription' )}:</label>
        <input class="halfbox" id="subscriptionEmail" type="text" name="Email" value="{cond( is_set( $user ), $user.email, $email)|wash}" title="{'Email of the subscriber.'|i18n( 'design/eznewsletter/register_subscription' )}"
               {cond( is_set( $user ), 'disabled="disabled"', '')} />
    </div>

    {if $subscriptionList.require_password}
        {* Password. *}
        <div class="block">
            <label>{"Password"|i18n( 'design/eznewsletter/register_subscription' )}:</label>
            <input name="Password1" size="25" type="password" value="password" {cond( is_set( $user ), 'readonly="readonly"', '' )} />
            <input name="Password2" size="25" type="password" value="password" {cond( is_set( $user ), 'readonly="readonly"', '' )} />
        </div>
    {/if}

    {if $output_map}
        <div class="block">
            <label>{"Output format"|i18n( 'design/eznewsletter/register_subscription' )}:</label>
            <select name="OutputFormat[]" multiple="multiple" title="{'Output format'|i18n( 'design/eznewsletter/register_subscription' )}">
            {foreach $output_map as $value => $out_name}
                <option value="{$value|wash}" {cond( eq($value, 2), 'selected="selected"', '')}>{$out_name|wash}</option>
            {/foreach}
        </select>
    </div>
    {/if}

    <div class="block">
        <input class="button" type="submit" name="StoreButton" value="{'Subscribe'|i18n( 'design/eznewsletter/register_subscription' )}" title="{'Add to subscription.'|i18n( 'design/eznewsletter/register_subscription' )}" />
    </div>

</form>

    </div>
</div>

</div></div></div></div></div>
</div>
