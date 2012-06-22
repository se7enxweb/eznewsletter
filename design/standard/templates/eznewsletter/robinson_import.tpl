{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{* eZNewsletter - subscriptions list *}
{def $base_uri=concat( 'newsletter/robinson_import' )}

{if is_set($warning)}
    <div class="message-warning">
        <h2>{$warning|wash}</h2>
    </div>
{/if}

<div class="context-block">
{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">
<h2 class="context-title">{'Opt-out list import'|i18n( 'design/eznewsletter/robinson_import' )}</h2>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-ml"><div class="box-mr"><div class="box-content">

<form enctype="multipart/form-data" name="robinson_import" method="post" action={$base_uri|ezurl}>
<div class="context-attributes">
    {* Name. *}
    
    <div class="element">

    <div class="element">
        <label>{"Upload file"|i18n( 'design/eznewsletter/robinson_import' )}:</label>
        <input type="checkbox" name="FirstRowLabel" checked="checked">{'First row is label'|i18n( 'design/eznewsletter/robinson_import' )}
        <div class="break"></div>
        <input type="hidden" name="MAX_FILE_SIZE" value="0" />
        <input name="UploadCSVFile" type="file" /><input type="submit" value="{'Upload file'|i18n( 'design/eznewsletter/robinson_import' )}" />
    </div>

    </div>

    <div class="element">
        <label>{'Import to list:'|i18n( 'design/eznewsletter/robinson_import' )}</label>
        <select name="import_list" size="4">
            {foreach $global_map as $value => $name}
                <option value="{$value}" {if is_set($import_list)}{cond( eq($value,$import_list), 'selected="selected"', '' )}{/if}>{$name|wash}</option>
            {/foreach}
    </select>
    </div>

    <div class="element">
            <label>{'Type of data:'|i18n( 'design/eznewsletter/robinson_import' )}</label>
            <select name="import_datatype" size="3">
                {foreach $type_map as $value => $name}
                    <option value="{$value}" {if is_set($import_datatype)}{cond( eq($value,$import_datatype), 'selected="selected"', '' )}{/if}>{$name|wash}</option>
                {/foreach}
            </select>
    </div>

    <div class="element">
            <label>{'Import options:'|i18n( 'design/eznewsletter/robinson_import' )}</label>
            <select name="import_options" size="4">
                {foreach $import_map as $value => $name}
                    <option value="{$value}" {if is_set($import_options)}{cond( eq($value,$import_options), 'selected="selected"', '' )}{/if}>{$name|wash}</option>
                {/foreach}
            </select>
    </div>

</div>

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">
<h2 class="context-title">{'Data to import'|i18n( 'design/eznewsletter/robinson_import' )}</h2>
{* DESIGN: Subline *}<div class="header-subline"></div>
{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN:  START *}<div class="box-ml"><div class="box-mr"><div class="box-content">
<div class="context-attributes">

{* Subscription import table. *}
<table class="list" cellspacing="0">
<tr>
    <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection'|i18n( 'design/eznewsletter/robinson_import' )}" title="{'Invert selection.'|i18n( 'design/eznewsletter/robinson_import' )}" onclick="ezjs_toggleCheckboxes( document.robinson_import, 'RowNum[]' ); return false;" /></th>
    <th class="tight">{'RowNum'|i18n( 'design/eznewsletter/robinson_import' )}</th>
    {def $maxCount=0}
    {foreach $data as $label => $dataSet}
        {set $maxCount=count( $dataSet )}
        <th>{$label|wash}</th>
    {/foreach}
</tr>
<tr>
   <td colspan="2">&nbsp;</td>
    {foreach $data as $label => $dataSet}
        <td><select name="LabelMap_{$label|wash}">
                <option value="0">{'None'|i18n( 'design/eznewsletter/robinson_import' )}</option>
                <option value="mobile">{'Mobile'|i18n( 'design/eznewsletter/robinson_import' )}</option>
                <option value="email">{'Email'|i18n( 'design/eznewsletter/robinson_import' )}</option>
            </select>
        </td>
    {/foreach}
</tr>

{if $maxCount|ge(1)}
    {set $maxCount=$maxCount|sub(1)}

{for 0 to $maxCount as $count 
    sequence array( bglight, bgdark ) as $seq}
    <tr class="{$seq}">
    <td><input type="checkbox" name="RowNum[]" value="{$count}" {if is_set($RowNum)}{cond( $RowNum|contains($count), 'checked="checked"', '' )}{/if} title="{'Select row to import'|i18n( 'design/eznewsletter/robinson_import' )}" /></td>
    <td class="number" align="right">{$count}</td>
    {foreach $data as $label => $dataSet}
        <td>{$dataSet[$count]|wash}</td>
    {/foreach}
    </tr>
{/for}

{/if}
</table>

{* DESIGN: Table END *}</div></div></div>

    <div class="controlbar">
{* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br">

    <input class="button" type="submit" name="CancelButton" value="{'Cancel'|i18n( 'design/eznewsletter/robinson_import' )}" title="{'Cancel subscription import.'|i18n( 'design/eznewsletter/robinson_import' )}" />
    <input class="button" type="submit" name="ImportButton" value="{'Import selected'|i18n( 'design/eznewsletter/robinson_import' )}" title="{'Import selected'|i18n( 'design/eznewsletter/robinson_import' )}" />

{* DESIGN: Control bar END *}</div></div></div></div></div></div>
    </div>
</form>

{* DESIGN: Content END *}</div></div></div>

    {* Buttons. *}
    <div class="controlbar">
{* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br">


{* DESIGN: Control bar END *}</div></div></div></div></div></div>
    </div>

