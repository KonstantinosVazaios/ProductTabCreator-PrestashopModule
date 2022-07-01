<?php   

/*
* 2007-2016 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2016 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/


if (!defined('_PS_VERSION_')) {
    exit;
}


class ProductTabCreator extends Module
{
    public $productId;
    public $tabTitle;
    public $tabRows = array();
    public $extraTabs;

    public function __construct()
    {
        $this->name = 'producttabcreator';
        $this->tab = 'dashboard';
        $this->version = '1.0.0';
        $this->author = 'Konstantinos Vazaios';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = array('min' => '1.6', 'max' => _PS_VERSION_); 
        $this->bootstrap = true;
    
        parent::__construct();
    
        $this->displayName = $this->l('Product Tab Creator');
        $this->description = $this->l('Certain products need additional information... With this module you can create as many tabs you wish for each product that contain extra information.');
    
        $this->confirmUninstall = $this->l('Are you sure you want to uninstall? Your created tabs will be lost and all the extra information for each of your products will not display to customers. You will not be able to restore your created tabs!');
    }
    
    public function install()
    {   
        return (parent::install()
            && $this->installDB()
			&& $this->registerHook('displayAdminAfterHeader')
            && $this->registerHook('displayFooterProduct')
			&& $this->registerHook('header')
			&& $this->registerHook('backOfficeHeader')
		);        
    }

    public function uninstall()
    {
        Configuration::deleteByName('producttabcreator');

        $this->uninstallDB();

		return parent::uninstall();
    }

    public function installDB()
	{
		$return = true;
		$return &= Db::getInstance()->execute('
			CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'producttab` (
				`id_producttab` INT UNSIGNED NOT NULL AUTO_INCREMENT,
				`id_product` int(10) unsigned NOT NULL,
				`title` VARCHAR(100) NOT NULL,
                `content` LONGTEXT NOT NULL,
				PRIMARY KEY (`id_producttab`)
			) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8 ;');

		return $return;
	}

    public function uninstallDB()
	{
		return Db::getInstance()->execute('DROP TABLE IF EXISTS `'._DB_PREFIX_.'producttab`');
	}

    public function hookDisplayAdminAfterHeader($params)
    { 
        Tools::isSubmit('createTabForm') && $this->validateData()->createTab();
        Tools::isSubmit('updateTabForm') && $this->validateData()->updateTab();
        Tools::isSubmit('deleteTabForm') && $this->deleteTab();

        $this->getTabs();

        $this->context->smarty->assign(array(
            'extraTabs' => $this->extraTabs
        ));

        return $this->display(__FILE__, 'views/templates/hook/producttabcreator-back.tpl');
    }

    // JS STYLING
    public function hookBackOfficeHeader() {
        Tools::getValue('controller') === 'AdminProducts' && Tools::getIsset('updateproduct')
        ? $this->context->controller->addJS($this->_path . 'views/js/producttabcreator.js')
        : null;
    }
    

    public function getTabs()
    {
        $productId = pSQL(Tools::getValue('id_product'));
        
        $sql = "SELECT * FROM ps_producttab WHERE id_product = {$productId}";

        $results = Db::getInstance()->ExecuteS($sql);

        for ($i=0; $i < count($results); $i++) { 
            $results[$i]['content'] = json_decode($results[$i]['content'], true);
        }

        $this->extraTabs = $results;        
    }


    public function validateData()
    {
        if (!Tools::getValue('tab_title')) {
            return;
        }

        $this->productId = Tools::getValue('id_product');
        $this->tabTitle = Tools::getValue('tab_title');

        $tabRowsTitle = Tools::getValue('row_title');
        $tabRowsContent = Tools::getValue('row_content');
        for ($i=0; $i < count($tabRowsTitle); $i++) { 
            if ($tabRowsTitle[$i] && $tabRowsContent[$i]) {
                $this->tabRows[$tabRowsTitle[$i]] = $tabRowsContent[$i];
            }
        }
        $this->tabRows = json_encode($this->tabRows);

        return $this;
    }

    public function createTab()
    {
        Db::getInstance()->insert('producttab', array(
            'id_product' => pSQL($this->productId),
            'title'      => pSQL($this->tabTitle),
            'content' => pSQL($this->tabRows)
        ));
    }
    
    public function updateTab()
    {
        $productTabId = Tools::getValue('tab_id');
        
        $data = array(
            'id_product' => pSQL($this->productId),
            'title'      => pSQL($this->tabTitle),
            'content' => pSQL($this->tabRows)
        );

        Db::getInstance()->update('producttab', $data, "id_producttab = {$productTabId}");
    }

    public function deleteTab()
    {   
        $productTabId = Tools::getValue('tab_id');

        Db::getInstance()->delete('producttab', "id_producttab = {$productTabId}");
    }


    public function hookDisplayFooterProduct()
    {
        $this->getTabs();

        $this->context->smarty->assign(array(
            'extraTabs' => $this->extraTabs
        ));
        return $this->display(__FILE__, 'views/templates/hook/producttabcreator-front.tpl');
    }

}