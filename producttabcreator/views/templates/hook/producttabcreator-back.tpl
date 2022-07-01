{if Tools::getValue('controller') === 'AdminProducts' && Tools::getIsset('updateproduct')}
	<div style="width: 100%; height: 50px">
        <div style="position: absolute; right: 10px;">
            <button data-toggle="modal" data-target=".inspect-tab-modal" style="margin-right: 10px" class="btn btn-success mb-5">View Additional Tabs</button>
		    <button data-toggle="modal" data-target=".create-tab-modal" style="" class="btn btn-primary mb-5">ADD NEW TAB TO PRODUCT</button>
        </div>
	</div>

    
    <div id="tabRowForCopy" style="display: none; margin-top: 25px" class="tab-row">
        <hr>
        <div class="form-group">
            <label for="rowtitle">Tab Row Title</label>
            <input name="row_title[]" type="text" class="form-control" id="rowtitle" aria-describedby="emailHelp">
        </div>
        <div class="form-group">
            <label for="exampleFormControlTextarea1">Tab Row Content</label>
            <textarea name="row_content[]" class="form-control" id="exampleFormControlTextarea1" rows="3"></textarea>
        </div>
        <hr>
    </div>



    <div class="modal fade inspect-tab-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div style="padding: 25px" class="modal-content">
                <ul class="nav nav-tabs" id="myTab" role="tablist">
                    {foreach from=$extraTabs item=extraTab}
                        <li class="nav-item">
                            <a class="nav-link active" id="{$extraTab['id_producttab']}-tab" data-toggle="tab" href="#{$extraTab['id_producttab']}" role="tab" aria-controls="{$extraTab['id_producttab']}" aria-selected="true">{$extraTab['title']}</a>
                        </li>
                    {foreachelse}
                        <h1>No extra tabs have been created</h1>
                    {/foreach}
                </ul>
                <div class="tab-content" id="myTabContent">
                    {foreach from=$extraTabs item=extraTab}
                        <div style="padding: 20px" class="tab-pane fade" id="{$extraTab['id_producttab']}" role="tabpanel" aria-labelledby="{$extraTab['id_producttab']}-tab">
                            <form id="updateTabForm{$extraTab['id_producttab']}" action="" method="post">
                                <input name="tab_id" type="hidden" value="{$extraTab['id_producttab']}">
                                <div class="form-group">
                                    <label for="tabtitle">Tab Title</label>
                                    <input name="tab_title" type="text" class="form-control" id="tabtitle" aria-describedby="emailHelp" value="{$extraTab['title']}" required>
                                </div>
                                <div id="tabRowContainer" data-type="updateTab{$extraTab['id_producttab']}">
                                    {foreach from=$extraTab['content'] key=title item=value}
                                        <div id="tabRow" style="margin-top: 25px" class="tab-row">
                                            <hr>
                                            <div class="form-group">
                                                <label for="rowtitle">Tab Row Title</label>
                                                <input name="row_title[]" type="text" class="form-control" id="rowtitle" aria-describedby="emailHelp" value="{$title}">
                                            </div>
                                            <div class="form-group">
                                                <label for="exampleFormControlTextarea1">Tab Row Content</label>
                                                <textarea name="row_content[]" class="form-control" id="exampleFormControlTextarea1" rows="3">{$value}</textarea>
                                            </div>
                                            <hr>
                                        </div>
                                    {{/foreach}}
                                </div>
                            </form>
                            <button id="addTabBtn" data-type="updateTab{$extraTab['id_producttab']}" style="width: 100%" class="btn btn-primary">ADD NEW TAB ROW</button>
                            <button name="updateTabForm" form="updateTabForm{$extraTab['id_producttab']}" type="submit" style="width: 100%; margin-top: 20px" class="btn btn-success">UPDATE TAB</button>
                            <form id="deleteTabForm{$extraTab['id_producttab']}" action="" method="post">
                                <input name="tab_id" type="hidden" value="{$extraTab['id_producttab']}">
                                <button name="deleteTabForm" form="deleteTabForm{$extraTab['id_producttab']}" type="submit" style="width: 100%; margin-top: 20px" class="btn btn-danger">DELETE TAB</button>
                            </form>
                        </div>
                    {/foreach}
                </div>
			</div>
		</div>
	</div>



	<div class="modal fade create-tab-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div style="padding: 25px" class="modal-content">
                <form id="createTabForm" action="" method="post">
                    <div class="form-group">
                        <label for="tabtitle">Tab Title</label>
                        <input name="tab_title" type="text" class="form-control" id="tabtitle" aria-describedby="emailHelp" placeholder="Enter the tab title" required>
                    </div>
                    <div id="tabRowContainer" data-type="createTab">
                        <div id="tabRow" style="margin-top: 25px" class="tab-row">
                            <hr>
                            <div class="form-group">
                                <label for="rowtitle">Tab Row Title</label>
                                <input name="row_title[]" type="text" class="form-control" id="rowtitle" aria-describedby="emailHelp" placeholder="Enter the tab title">
                            </div>
                            <div class="form-group">
                                <label for="exampleFormControlTextarea1">Tab Row Content</label>
                                <textarea name="row_content[]" class="form-control" id="exampleFormControlTextarea1" rows="3"></textarea>
                            </div>
                            <hr>
                        </div>
                    </div>
                </form>
				<button id="addTabBtn" data-type="createTab" style="width: 100%" class="btn btn-primary">ADD NEW TAB ROW</button>
				<button name="createTabForm" form="createTabForm" type="submit" style="width: 100%; margin-top: 20px" class="btn btn-success">CREATE TAB</button>
			</div>
		</div>
	</div>
{/if}