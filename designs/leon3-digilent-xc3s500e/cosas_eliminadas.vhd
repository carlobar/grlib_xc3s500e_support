-- cosas removidas

    -- ethernet signals
    emdio   : inout std_logic;          -- ethernet PHY interface
    etx_clk : in    std_ulogic;
    erx_clk : in    std_ulogic;
    erxd    : in    std_logic_vector(3 downto 0);
    erx_dv  : in    std_ulogic;
    erx_er  : in    std_ulogic;
    erx_col : in    std_ulogic;
    erx_crs : in    std_ulogic;
    etxd    : out   std_logic_vector(3 downto 0);
    etx_en  : out   std_ulogic;
    etx_er  : out   std_ulogic;
    emdc    : out   std_ulogic;





 signal ethi, ethi1, ethi2 : eth_in_type;
  signal etho, etho1, etho2 : eth_out_type;



-----------------------------------------------------------------------
---  ETHERNET ---------------------------------------------------------
-----------------------------------------------------------------------

  eth0 : if CFG_GRETH = 1 generate -- Gaisler ethernet MAC
      e1 : grethm generic map(hindex => CFG_NCPU+CFG_AHB_UART+CFG_AHB_JTAG+CFG_SVGA_ENABLE,
	pindex => 15, paddr => 15, pirq => 12, memtech => memtech,
        mdcscaler => CPU_FREQ/1000, enable_mdio => 1, fifosize => CFG_ETH_FIFO,
        nsync => 1, edcl => CFG_DSU_ETH, edclbufsz => CFG_ETH_BUF,
        macaddrh => CFG_ETH_ENM, macaddrl => CFG_ETH_ENL, 
	ipaddrh => CFG_ETH_IPM, ipaddrl => CFG_ETH_IPL,
	phyrstadr => 31, giga => CFG_GRETH1G)
     port map( rst => rstn, clk => clkm, ahbmi => ahbmi,
        ahbmo => ahbmo(CFG_NCPU+CFG_AHB_UART+CFG_AHB_JTAG+CFG_SVGA_ENABLE), 
	apbi => apbi, apbo => apbo(15), ethi => ethi, etho => etho); 

    emdio_pad : iopad generic map (tech => padtech)
      port map (emdio, etho.mdio_o, etho.mdio_oe, ethi.mdio_i);
    etxc_pad : inpad generic map (tech => padtech)
      port map (etx_clk, ethi.tx_clk);
    erxc_pad : inpad generic map (tech => padtech)
      port map (erx_clk, ethi.rx_clk);
    erxd_pad : inpadv generic map (tech => padtech, width => 4)
      port map (erxd, ethi.rxd(3 downto 0));
    erxdv_pad : inpad generic map (tech => padtech)
      port map (erx_dv, ethi.rx_dv);
    erxer_pad : inpad generic map (tech => padtech)
      port map (erx_er, ethi.rx_er);
    erxco_pad : inpad generic map (tech => padtech)
      port map (erx_col, ethi.rx_col);
    erxcr_pad : inpad generic map (tech => padtech)
      port map (erx_crs, ethi.rx_crs);

    etxd_pad : outpadv generic map (tech => padtech, width => 4)
      port map (etxd, etho.txd(3 downto 0));
    etxen_pad : outpad generic map (tech => padtech)
      port map (etx_en, etho.tx_en);
    etxer_pad : outpad generic map (tech => padtech)
      port map (etx_er, etho.tx_er);
    emdc_pad : outpad generic map (tech => padtech)
      port map (emdc, etho.mdc);

  end generate;

