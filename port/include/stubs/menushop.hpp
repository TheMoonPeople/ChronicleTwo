#pragma once

struct SHOP_PRICE_INFO;

/** Native shop-list loading fills the shop script's parse state. */
extern short            Now_ShopListNum asm("MenuShop_NowShopListNum");
extern int             *Now_ShopDataReadPtr asm("MenuShop_NowShopDataReadPtr");
extern short            Now_Shop_ID asm("MenuShop_NowShopId");
extern SHOP_PRICE_INFO *Spi_PriceList asm("MenuShop_PriceList");
extern short            NowSellMode asm("MenuShop_NowSellMode");
