<section class="page-product-box">
    {foreach from=$extraTabs item=extraTab}
        <h3 class="page-product-heading">{$extraTab['title']}</h3>
        <table class="table-data-sheet">
            {foreach from=$extraTab['content'] key=title item=value}
            <tr class="odd">
                <td>{$title}</td>
                <td>{$value}</td>
            </tr>
            {/foreach}
        </table>
    {/foreach}
</section>