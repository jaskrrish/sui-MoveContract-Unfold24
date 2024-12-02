#[allow(duplicate_alias)]
module test_nft::professional_nft {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::string::{String};

    // Struct representing the Professional NFT
    public struct ProfessionalNFT has key, store {
        id: UID,
        title : String,
        description: String,
        image_url: String,
        github_url: String,
        twitter_url: String,
        contract_address: address,
        ai_score: u8
    }

    // Admin capability for managing the NFT collection
    public struct AdminCap has key, store {
        id: UID
    }

    // One-time witness for creating the NFT collection
    public struct PROFESSIONAL_NFT has drop {}

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(PROFESSIONAL_NFT{}, ctx);
    }

    // Initialization function
    fun init(_otw: PROFESSIONAL_NFT, ctx: &mut TxContext) {
        // Create and transfer admin capabilities
        let admin_cap = AdminCap {
            id: object::new(ctx)
        };
        transfer::public_transfer(admin_cap, tx_context::sender(ctx));
    }

    // Mint a new Professional NFT
    public fun mint_professional_nft(
        title: String,
        description: String, 
        image_url: String, 
        github_url: String, 
        twitter_url: String,
        contract_address: address,
        ai_score: u8,
        recipient: address,
        ctx: &mut TxContext
    ) {
        // Validate AI score (assuming 0-100 scale)
        assert!(ai_score <= 100, 0);

        // Create the NFT
        let nft = ProfessionalNFT {
            id: object::new(ctx),
            title,
            description,
            image_url,
            github_url,
            twitter_url,
            contract_address,
            ai_score
        };

        // Transfer the NFT to the recipient
        transfer::transfer(nft, recipient);
    }

    // Update NFT description
    public fun update_title(nft: &mut ProfessionalNFT, title: String) {
        nft.title = title;
    }

    public fun update_description(nft: &mut ProfessionalNFT, new_description: String) {
        nft.description = new_description;
    }

    // Update image URL
    public fun update_image_url(nft: &mut ProfessionalNFT, new_image_url: String) {
        nft.image_url = new_image_url;
    }

    // Update AI score
    public fun update_ai_score(nft: &mut ProfessionalNFT, new_ai_score: u8) {
        // Validate AI score
        assert!(new_ai_score <= 100, 0);
        nft.ai_score = new_ai_score;
    }

    public fun get_title(nft: &ProfessionalNFT): String {
        nft.title
    }

    // Accessor functions
    public fun get_description(nft: &ProfessionalNFT): String {
        nft.description
    }

    public fun get_image_url(nft: &ProfessionalNFT): String {
        nft.image_url
    }

    public fun get_github_url(nft: &ProfessionalNFT): String {
        nft.github_url
    }

    public fun get_twitter_url(nft: &ProfessionalNFT): String {
        nft.twitter_url
    }

    public fun get_contract_address(nft: &ProfessionalNFT): address {
        nft.contract_address
    }

    public fun get_ai_score(nft: &ProfessionalNFT): u8 {
        nft.ai_score
    }

    // Function to burn (destroy) the NFT
    public fun burn(nft: ProfessionalNFT) {
        let ProfessionalNFT { 
            id,
            title: _,
            description: _, 
            image_url: _, 
            github_url: _, 
            twitter_url: _,
            contract_address: _,
            ai_score: _ 
        } = nft;
        object::delete(id);
    }
}